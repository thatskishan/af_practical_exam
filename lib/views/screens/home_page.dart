import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/database_controller.dart';
import '../../models/product_models.dart';

class ProductCart extends StatefulWidget {
  const ProductCart({Key? key}) : super(key: key);

  @override
  State<ProductCart> createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart> {
  DataBaseController dataBaseController = Get.find();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await dataBaseController.loadString(
          path: "assets/json/product_data.json");
      await dataBaseController.init();
      await dataBaseController.insertBulkRecord();
      await dataBaseController.fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
        title: Text(
          "MyShop",
          style: GoogleFonts.poppins(),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Obx(
        () => (dataBaseController.productList.value.isEmpty)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: dataBaseController.productList.length,
                        itemBuilder: (context, index) {
                          Product product =
                              dataBaseController.productList[index];
                          return Column(
                            children: [
                              Container(
                                // height: 370,
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(bottom: 20),

                                decoration: BoxDecoration(
                                  color: Colors.indigoAccent.withOpacity(0.5),
                                  border: Border.all(
                                      width: 2, color: Colors.indigo),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 400,
                                      decoration: const BoxDecoration(),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            right: 10, top: 5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: MemoryImage(
                                              base64Decode(product.image!),
                                            ),
                                          ),
                                        ),
                                        child: (index ==
                                                dataBaseController
                                                    .randomNumber.value)
                                            ? Align(
                                                alignment: Alignment.topRight,
                                                child: Obx(
                                                  () => Text(
                                                    "Stock Out in ${dataBaseController.countDown.value}s",
                                                    style: GoogleFonts.poppins(
                                                      color:
                                                          Colors.red.shade800,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 24,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "${product.name}",
                                        style: GoogleFonts.poppins(
                                            fontSize: 24,
                                            color: Colors.indigoAccent,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Quantity:- ${product.quantity} pcs.",
                                      style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    if (product.quantity != 0)
                                      InkWell(
                                        onTap: () {
                                          if (dataBaseController
                                                      .randomNumber.value ==
                                                  index &&
                                              dataBaseController
                                                      .countDown.value >=
                                                  20) {
                                            dataBaseController
                                                .isAddToCart(true);
                                          }

                                          dataBaseController.addToCart(
                                              product: product);
                                        },
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            "Add To Cart",
                                            style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 22),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
