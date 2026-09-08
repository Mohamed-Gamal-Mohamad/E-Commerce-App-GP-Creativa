// lib/features/product/views/manage_products_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../data/services/product_service.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';

/// Screen to add new products and delete existing ones.
/// Uses ManageProductsCubit to interact with DummyJSON API.
class ManageProductsScreen extends StatelessWidget {
  const ManageProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ManageProductsCubit(context.read<ProductService>())
        ..loadProducts(),
      child: const _ManageProductsView(),
    );
  }
}

class _ManageProductsView extends StatefulWidget {
  const _ManageProductsView();

  @override
  State<_ManageProductsView> createState() => _ManageProductsViewState();
}

class _ManageProductsViewState extends State<_ManageProductsView> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _brandCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    _categoryCtrl.dispose();
    _brandCtrl.dispose();
    super.dispose();
  }

  void _showAddProductSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: ctx.read<ManageProductsCubit>(),
        child: _AddProductSheet(
          formKey: _formKey,
          titleCtrl: _titleCtrl,
          priceCtrl: _priceCtrl,
          descCtrl: _descCtrl,
          categoryCtrl: _categoryCtrl,
          brandCtrl: _brandCtrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Products',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        actions: [
          BlocBuilder<ManageProductsCubit, ManageProductsState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: TextButton.icon(
                  onPressed: () => _showAddProductSheet(context),
                  icon: const Icon(Icons.add_rounded, color: AppColors.primary),
                  label: Text(
                    'Add',
                    style: GoogleFonts.poppins(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ManageProductsCubit, ManageProductsState>(
        listener: (context, state) {
          if (state is ManageProductsActionSuccess) {
            Navigator.of(context).pop(); // close bottom sheet if open
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
          } else if (state is ManageProductsError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
          }
        },
        builder: (context, state) {
          if (state is ManageProductsLoading) {
            return const LoadingWidget();
          }

          List<dynamic> products = [];
          if (state is ManageProductsLoaded) products = state.products;
          if (state is ManageProductsActionSuccess) products = state.products;

          if (products.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.inventory_2_outlined,
              title: 'No Products',
              subtitle: 'Tap + Add to create a product.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: product.thumbnail,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        width: 56,
                        height: 56,
                        color: AppColors.lightSurfaceVariant,
                        child: const Icon(Icons.image_outlined, size: 24),
                      ),
                    ),
                  ),
                  title: Text(
                    product.title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.error,
                    ),
                    onPressed: () => _confirmDelete(context, product.id, product.title),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id, String title) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Product', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: Text('Remove "$title"?', style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<ManageProductsCubit>().deleteProduct(id);
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet form for adding a new product.
class _AddProductSheet extends StatelessWidget {
  const _AddProductSheet({
    required this.formKey,
    required this.titleCtrl,
    required this.priceCtrl,
    required this.descCtrl,
    required this.categoryCtrl,
    required this.brandCtrl,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController titleCtrl;
  final TextEditingController priceCtrl;
  final TextEditingController descCtrl;
  final TextEditingController categoryCtrl;
  final TextEditingController brandCtrl;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(
          24,
          16,
          24,
          MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Form(
          key: formKey,
          child: ListView(
            controller: scrollController,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Add New Product',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: titleCtrl,
                label: 'Product Title',
                prefixIcon: Icons.label_outline_rounded,
                textInputAction: TextInputAction.next,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: priceCtrl,
                label: 'Price (\$)',
                prefixIcon: Icons.attach_money_rounded,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (double.tryParse(v) == null) return 'Invalid price';
                  return null;
                },
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: brandCtrl,
                label: 'Brand',
                prefixIcon: Icons.business_outlined,
                textInputAction: TextInputAction.next,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: categoryCtrl,
                label: 'Category',
                prefixIcon: Icons.category_outlined,
                textInputAction: TextInputAction.next,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: descCtrl,
                label: 'Description',
                prefixIcon: Icons.description_outlined,
                maxLines: 3,
                textInputAction: TextInputAction.newline,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              BlocBuilder<ManageProductsCubit, ManageProductsState>(
                builder: (context, state) {
                  return CustomButton(
                    label: 'Save Product',
                    icon: Icons.save_rounded,
                    isLoading: state is ManageProductsLoading,
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        context.read<ManageProductsCubit>().addProduct(
                              title: titleCtrl.text,
                              price: double.parse(priceCtrl.text),
                              description: descCtrl.text,
                              category: categoryCtrl.text,
                              brand: brandCtrl.text,
                            );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

