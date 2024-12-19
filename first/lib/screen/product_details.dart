import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'HomeScreen.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetails extends StatelessWidget {
  final Product product;

  const ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.name,
          style: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 19,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 160, 189, 159),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: GoogleFonts.cairo(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showZoomableImage(context, product.image2Url),
                    child: Image.asset(
                      product.image2Url,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showZoomableImage(context, product.imageUrl),
                    child: Image.asset(
                      product.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              product.description,
              style: GoogleFonts.cairo(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour afficher une image zoomable
  void _showZoomableImage(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
          ),
          body: Center(
            child: PhotoView(
              imageProvider: AssetImage(imageUrl),
              backgroundDecoration: const BoxDecoration(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
