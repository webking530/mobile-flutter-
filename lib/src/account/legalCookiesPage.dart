import 'package:flutter/material.dart';
import 'package:fitemos/src/model/apisModal.dart';
import 'package:google_fonts/google_fonts.dart';

class LegalCookie extends StatefulWidget {
  final conTitle;
  LegalCookie({Key key, this.conTitle}) : super(key: key);

  @override
  _legalCookieState createState() => _legalCookieState();
}

class _legalCookieState extends State<LegalCookie> {
   get conTitle => widget.conTitle;
   Widget _backButton() {
     return  Container(
       padding: EdgeInsets.only(top: 30),
       width: MediaQuery.of(context).size.width,
       color: Colors.white,
       height: 90,
       child: Row(
         children: <Widget>[
           InkWell(
               onTap: () {
                 Navigator.pop(context);
               },
               child: Container(
                 padding: EdgeInsets.only(left: 12, top: 11, bottom: 10),
                 child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
               )),
           Container(
             padding: EdgeInsets.only(left: 6, top: 11, bottom: 10),
             child: Text(conTitle,
                 style: GoogleFonts.nunito(fontSize: 21, fontWeight: FontWeight.bold, color: Color(0xff333333))),
           ),
         ],
       ),
     );
   }

   Widget _detailBody() {
     return  Container(
       width: MediaQuery.of(context).size.width,
       padding: EdgeInsets.symmetric(horizontal: 20),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         mainAxisAlignment: MainAxisAlignment.start,
         children: <Widget>[
           SizedBox(height: 10),
           Padding(
             padding: EdgeInsets.only(left: 0),
             child: Text('AVISO DE COOKIES',
                 style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff333333))),
           ),
           SizedBox(height: 5),
           RichText(
             textAlign: TextAlign.justify,
             text: TextSpan(
               text: 'Utilizamos cookies propias y de terceros para obtener datos estad??sticos de la navegaci??n de nuestros ???Usuarios??? y mejorar nuestros servicios. Si acepta o contin??a navegando, consideramos que acepta su uso. Puede cambiar la configuraci??n u obtener m??s informaci??n aqu?? (enlace a p??gina de cookies).',
               style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff333333)),
             ),
           ),
           SizedBox(height: 10),
           Padding(
             padding: EdgeInsets.only(left: 0),
             child: Text('??QU?? SON LAS COOKIES?',
                 style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff333333))),
           ),
           SizedBox(height: 5),
           RichText(
             textAlign: TextAlign.justify,
             text: TextSpan(
               text: 'Una cookie es un fichero que se descarga en su ordenador al acceder a determinadas p??ginas web. Las cookies permiten a una p??gina web, entre otras cosas, almacenar y recuperar informaci??n sobre los h??bitos de navegaci??n de un usuario o de su equipo y, dependiendo de la informaci??n que contengan y de la forma en que utilice su equipo, pueden utilizarse para reconocer al usuario.',
               style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff333333)),
             ),
           ),
           SizedBox(height: 10),
           Padding(
             padding: EdgeInsets.only(left: 0),
             child: Text('??QU?? TIPOS DE COOKIES UTILIZA ESTA P??GINA WEB?',
                 style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff333333))),
           ),
           SizedBox(height: 5),
           RichText(
             textAlign: TextAlign.justify,
             text: TextSpan(
               text: 'Esta p??gina web utiliza los siguientes tipos de cookies:',
               style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff333333)),
             ),
           ),
           SizedBox(height: 5),
           RichText(
             textAlign: TextAlign.justify,
             text: TextSpan(
               text: 'Cookies de an??lisis',
               style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff333333)),
               children: <TextSpan>[
                 TextSpan(text: ': Son aqu??llas que bien tratadas por nosotros o por terceros, nos permiten cuantificar el n??mero de usuarios y as?? realizar la medici??n y an??lisis estad??stico de la utilizaci??n que hacen los usuarios del servicio ofertado. Para ello se analiza su navegaci??n en nuestra p??gina web con el fin de mejorar la oferta de productos o servicios que le ofrecemos.', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff333333))),
               ],
             ),
           ),
           SizedBox(height: 5),
           RichText(
             textAlign: TextAlign.justify,
             text: TextSpan(
               text: 'Cookies t??cnicas',
               style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff333333)),
               children: <TextSpan>[
                 TextSpan(text: ': Son aquellas que permiten al usuario la navegaci??n a trav??s del ??rea restringida y la utilizaci??n de sus diferentes funciones, como, por ejemplo, llevar a cambio el proceso de compra de un art??culo.', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff333333))),
               ],
             ),
           ),
           SizedBox(height: 5),
           RichText(
             textAlign: TextAlign.justify,
             text: TextSpan(
               text: 'Cookies de personalizaci??n',
               style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff333333)),
               children: <TextSpan>[
                 TextSpan(text: ': Son aquellas que permiten al usuario acceder al servicio con algunas caracter??sticas de car??cter general predefinidas en funci??n de una serie de criterios en el terminal del usuario como por ejemplo serian el idioma o el tipo de navegador a trav??s del cual se conecta al servicio.', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff333333))),
               ],
             ),
           ),
           SizedBox(height: 5),
           RichText(
             textAlign: TextAlign.justify,
             text: TextSpan(
               text: 'Cookies publicitarias',
               style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff333333)),
               children: <TextSpan>[
                 TextSpan(text: ': Son aqu??llas que, bien tratadas por esta web o por terceros, permiten gestionar de la forma m??s eficaz posible la oferta de los espacios publicitarios que hay en la p??gina web, adecuando el contenido del anuncio al contenido del servicio solicitado o al uso que realice de nuestra p??gina web. Para ello podemos analizar sus h??bitos de navegaci??n en Internet y podemos mostrarle publicidad relacionada con su perfil de navegaci??n.', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff333333))),
               ],
             ),
           ),
           SizedBox(height: 5),
           RichText(
             textAlign: TextAlign.justify,
             text: TextSpan(
               text: 'Cookies de publicidad comportamental',
               style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff333333)),
               children: <TextSpan>[
                 TextSpan(text: ': Son aquellas que permiten la gesti??n, de la forma m??s eficaz posible, de los espacios publicitarios que, en su caso, el editor haya incluido en una p??gina web, aplicaci??n o plataforma desde la que presta el servicio solicitado. Este tipo de cookies almacenan informaci??n del comportamiento de los visitantes obtenida a trav??s de la observaci??n continuada de sus h??bitos de navegaci??n, lo que permite desarrollar un perfil espec??fico para mostrar avisos publicitarios en funci??n del mismo.', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff333333))),
               ],
             ),
           ),
           SizedBox(height: 10),
           Padding(
             padding: EdgeInsets.only(left: 0),
             child: Text('DESACTIVAR LAS COOKIES.',
                 style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff333333))),
           ),
           SizedBox(height: 5),
           Padding(
             padding: EdgeInsets.only(left: 0),
             child: RichText(
               textAlign: TextAlign.justify,
               text: TextSpan(
                 text: 'Puede usted ',
                 style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff333333)),
                 children: <TextSpan>[
                   TextSpan(text: 'permitir, bloquear o eliminar las cookies', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff333333))),
                   TextSpan(text: ' instaladas en su equipo mediante la configuraci??n de las opciones del navegador instalado en su ordenador.', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff333333))),
                 ],
               ),
             ),
           ),
           SizedBox(height: 5),
           RichText(
             textAlign: TextAlign.justify,
             text: TextSpan(
               text: 'En la mayor??a de los navegadores web se ofrece la posibilidad de permitir, bloquear o eliminar las cookies instaladas en su equipo.',
               style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff333333)),
             ),
           ),
           SizedBox(height: 10),
           Padding(
             padding: EdgeInsets.only(left: 0),
             child: Text('COOKIES DE TERCEROS.',
                 style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff333333))),
           ),
           SizedBox(height: 5),
           RichText(
             textAlign: TextAlign.justify,
             text: TextSpan(
               text: 'Este ???Sitio Web??? utiliza servicios de terceros para recopilar informaci??n con fines estad??sticos y de uso de la web.',
               style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff333333)),
             ),
           ),
           SizedBox(height: 10),
           Padding(
             padding: EdgeInsets.only(left: 0),
             child: Text('ADVERTENCIA SOBRE ELIMINAR COOKIES.',
                 style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xff333333))),
           ),
           SizedBox(height: 5),
           RichText(
             textAlign: TextAlign.justify,
             text: TextSpan(
               text: 'Usted puede eliminar y bloquear todas las cookies de este ???Sitio Web???, pero parte del sitio no funcionar?? o la calidad de la p??gina web puede verse afectada.',
               style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff333333)),
             ),
           ),
           SizedBox(height: 10),
           RichText(
             textAlign: TextAlign.justify,
             text: TextSpan(
               text: 'Si tiene cualquier duda acerca de nuestra pol??tica de cookies, puede contactarnos a: ',
               style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff333333)),
               children: <TextSpan>[
                 TextSpan(text: 'soporte@fitemos.com', style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xff149dcc))),
               ],
             ),
           ),
         ],
       ),
     );
   }

   @override
   Widget build(BuildContext context) {
     var size = MediaQuery.of(context).size;
     return Scaffold(
         body: Container(
           width: size.width,
           decoration: BoxDecoration(color: Color(0xffFFFFFF)),
           child: Stack(
             children: <Widget>[
               Container(
                 child: SingleChildScrollView(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       SizedBox(height: 100),
                       _detailBody(),
                       SizedBox(height: 30),
                     ],
                   ),
                 ),
               ),
               Positioned(top: 0, left: 0, child: _backButton()),
             ],
           ),
         )
     );
   }
}