#
# Implementation by Pedro Maat C. Massolino, hereby denoted as "the implementer".
#
# To the extent possible under law, the implementer has waived all copyright
# and related or neighboring rights to the source code in this file.
# http://creativecommons.org/publicdomain/zero/1.0/
#
sidh_constants = [
[
"p16",
# prime constant f
1,
# prime constant ea
2,
# prime constant eb
3,
# prime constant la
8,
# prime constant lb
5,
# coordinate x of point PA - Real
0x7F4,
# coordinate x of point PA - Imaginary
0x1641,
# coordinate x of point QA - Real
0xDCC,
# coordinate x of point QA - Imaginary
0x6DF,
# coordinate x of point RA - Real
0x2490,
# coordinate x of point RA - Imaginary
0x3796,
# coordinate x of point PB - Real
0x64B7,
# coordinate x of point PB - Imaginary
0x0,
# coordinate x of point QB - Real
0x80A2,
# coordinate x of point QB - Imaginary
0x0,
# coordinate x of point RB - Real
0x65DC,
# coordinate x of point RB - Imaginary
0xC5E0,
# splits Alice
[2, 1, 1],
# max Alice row
4,
# max Alice points
2,
# splits Bob
[2, 1, 1, 1],
# max Bob row
5,
# max Bob points
3,
# SIKE SK length, also known as message length
16,
# SIKE shared secret length
16,
],
[
"p434",
# prime constant f
1,
# prime constant ea
2,
# prime constant eb
3,
# prime constant la
216,
# prime constant lb
137,
# coordinate x of point PA - Real
0x3CCFC5E1F050030363E6920A0F7A4C6C71E63DE63A0E6475AF621995705F7C84500CB2BB61E950E19EAB8661D25C4A50ED279646CB48,
# coordinate x of point PA - Imaginary
0x1AD1C1CAE7840EDDA6D8A924520F60E573D3B9DFAC6D189941CB22326D284A8816CC4249410FE80D68047D823C97D705246F869E3EA50,
# coordinate x of point QA - Real
0xC7461738340EFCF09CE388F666EB38F7F3AFD42DC0B664D9F461F31AA2EDC6B4AB71BD42F4D7C058E13F64B237EF7DDD2ABC0DEB0C6C,
# coordinate x of point QA - Imaginary
0x25DE37157F50D75D320DD0682AB4A67E471586FBC2D31AA32E6957FA2B2614C4CD40A1E27283EAAF4272AE517847197432E2D61C85F5,
# coordinate x of point RA - Real
0xF37AB34BA0CEAD94F43CDC50DE06AD19C67CE4928346E829CB92580DA84D7C36506A2516696BBE3AEB523AD7172A6D239513C5FD2516,
# coordinate x of point RA - Imaginary
0x196CA2ED06A657E90A73543F3902C208F410895B49CF84CD89BE9ED6E4EE7E8DF90B05F3FDB8BDFE489D1B3558E987013F9806036C5AC,
# coordinate x of point PB - Real
0x8664865EA7D816F03B31E223C26D406A2C6CD0C3D667466056AAE85895EC37368BFC009DFAFCB3D97E639F65E9E45F46573B0637B7A9,
# coordinate x of point PB - Imaginary
0x0,
# coordinate x of point QB - Real
0x12E84D7652558E694BF84C1FBDAAF99B83B4266C32EC65B10457BCAF94C63EB063681E8B1E7398C0B241C19B9665FDB9E1406DA3D3846,
# coordinate x of point QB - Imaginary
0x0,
# coordinate x of point RB - Real
0x1CD28597256D4FFE7E002E87870752A8F8A64A1CC78B5A2122074783F51B4FDE90E89C48ED91A8F4A0CCBACBFA7F51A89CE518A52B76C,
# coordinate x of point RB - Imaginary
0x147073290D78DD0CC8420B1188187D1A49DBFA24F26AAD46B2D9BB547DBB6F63A760ECB0C2B20BE52FB77BD2776C3D14BCBC404736AE4,
# splits Alice
[43, 28, 16, 9, 5, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 4, 2, 1, 1, 1, 2, 1, 1, 7, 4, 2, 1, 1, 1, 2, 1, 1, 3, 2, 1, 1, 1, 1, 12, 7, 4, 2, 1, 1, 1, 2, 1, 1, 3, 2, 1, 1, 1, 1, 5, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 16, 11, 7, 4, 2, 1, 1, 1, 2, 1, 1, 3, 2, 1, 1, 1, 1, 4, 3, 2, 1, 1, 1, 1, 2, 1, 1, 7, 4, 2, 1, 1, 1, 2, 1, 1, 3, 2, 1, 1, 1, 1],
# max Alice row
108,
# max Alice points
8,
# splits Bob
[49, 33, 21, 13, 8, 5, 3, 2, 1, 1, 1, 1, 1, 2, 1, 1, 1, 3, 2, 1, 1, 1, 1, 1, 5, 3, 2, 1, 1, 1, 1, 1, 2, 1, 1, 1, 8, 5, 3, 2, 1, 1, 1, 1, 1, 2, 1, 1, 1, 3, 2, 1, 1, 1, 1, 1, 12, 8, 5, 3, 2, 1, 1, 1, 1, 1, 2, 1, 1, 1, 3, 2, 1, 1, 1, 1, 1, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1, 1, 16, 12, 8, 5, 3, 2, 1, 1, 1, 1, 1, 2, 1, 1, 1, 3, 2, 1, 1, 1, 1, 1, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1, 1, 5, 3, 3, 2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1],
# max Bob row
137,
# max Bob points
10,
# SIKE SK length, also known as message length
16,
# SIKE shared secret length
16,
],
[
"p503",
# prime constant f
1,
# prime constant ea
2,
# prime constant eb
3,
# prime constant la
250,
# prime constant lb
159,
# coordinate x of point PA - Real
0x0002ED31A03825FA14BC1D92C503C061D843223E611A92D7C5FBEC0F2C915EE7EEE73374DF6A1161EA00CDCB786155E21FD38220C3772CE670BC68274B851678,
# coordinate x of point PA - Imaginary
0x001EE4E4E9448FBBAB4B5BAEF280A99B7BF86A1CE05D55BD603C3BA9D7C08FD8DE7968B49A78851FFBC6D0A17CB2FA1B57F3BABEF87720DD9A489B5581F915D2,
# coordinate x of point QA - Real
0x00325CF6A8E2C6183A8B9932198039A7F965BA8587B67925D08D809DBF9A69DE1B621F7F134FA2DAB82FF5A2615F92CC71419FFFAAF86A290D604AB167616461,
# coordinate x of point QA - Imaginary
0x003E7B0494C8E60A8B72308AE09ED34845B34EA0911E356B77A11872CF7FEEFF745D98D0624097BC1AD7CD2ADF7FFC2C1AA5BA3C6684B964FA555A0715E57DB1,
# coordinate x of point RA - Real
0x003D24CF1F347F1DA54C1696442E6AFC192CEE5E320905E0EAB3C9D3FB595CA26C154F39427A0416A9F36337354CF1E6E5AEDD73DF80C710026D49550AC8CE9F,
# coordinate x of point RA - Imaginary
0x0006869EA28E4CEE05DCEE8B08ACD59775D03DAA0DC8B094C85156C212C23C72CB2AB2D2D90D46375AA6D66E58E44F8F219431D3006FDED7993F51649C029498,
# coordinate x of point PB - Real
0x0032D03FD1E99ED0CB05C0707AF74617CBEA5AC6B75905B4B54B1B0C2D73697840155E7B1005EFB02B5D02797A8B66A5D258C76A3C9EF745CECE11E9A178BADF,
# coordinate x of point PB - Imaginary
0x0,
# coordinate x of point QB - Real
0x0039014A74763076675D24CF3FA28318DAC75BCB04E54ADDC6494693F72EBB7DA7DC6A3BBCD188DAD5BECE9D6BB4ABDD05DB38C5FBE52D985DCAF74422C24D53,
# coordinate x of point QB - Imaginary
0x0,
# coordinate x of point RB - Real
0x0000C1465FD048FFB8BF2158ED57F0CFFF0C4D5A4397C7542D722567700FDBB8B2825CAB4B725764F5F528294B7F95C17D560E25660AD3D07AB011D95B2CB522,
# coordinate x of point RB - Imaginary
0x00288165466888BE1E78DB339034E2B8C7BDF0483BFA7AB943DFA05B2D1712317916690F5E713740E7C7D4838296E67357DC34E3460A95C330D5169721981758,
# splits Alice
[61, 32, 16, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 16, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 29, 16, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 13, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 5, 4, 2, 1, 1, 2, 1, 1, 2, 1, 1, 1],
# max Alice row
125,
# max Alice points
7,
# splits Bob
[71, 38, 21, 13, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 5, 4, 2, 1, 1, 2, 1, 1, 2, 1, 1, 1, 9, 5, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 4, 2, 1, 1, 1, 2, 1, 1, 17, 9, 5, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 4, 2, 1, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 33, 17, 9, 5, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 4, 2, 1, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 16, 8, 4, 2, 1, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1],
# max Bob row
159,
# max Bob points
8,
# SIKE SK length, also known as message length
24,
# SIKE shared secret length
24,
],
[
"p610",
# prime constant f
1,
# prime constant ea
2,
# prime constant eb
3,
# prime constant la
305,
# prime constant lb
192,
# coordinate x of point PA - Real
0x00000001B368BC6019B46CD802129209B3E65B98BC64A92BC4DB2F9F3AC96B97A1B9C124DF549B528F18BEECB1666D27D47530435E84221272F3A97FB80527D8F8A359F8F1598D365744CA3070A5F26C,
# coordinate x of point PA - Imaginary
0x00000001459685DCA7112D1F6030DBC98F2C9CBB41617B6AD913E6523416CCBD8ED9C7841D97DF83092B9B3F2AF00D62E08DAD8FA743CBCCCC1782BE0186A3432D3C97C37CA16873BEDE01F0637C1AA2,
# coordinate x of point QA - Real
0x0000000025DA39EC90CDFB9BC0F772CDA52CB8B5A9F478D7AF8DBBA0AEB3E52432822DD88C38F4E3AEC0746E56149F1FE89707C77F8BA4134568629724F4A8E34B06BFE5C5E66E0867EC38B283798B8A,
# coordinate x of point QA - Imaginary
0x00000002250E1959256AE502428338CB4715399551AEC78D8935B2DC73FCDCFBDB1A0118A2D3EF03489BA6F637B1C7FEE7E5F31340A1A537B76B5B736B4CDD284918918E8C986FC02741FB8C98F0A0ED,
# coordinate x of point RA - Real
0x00000001B36A006D05F9E370D5078CCA54A16845B2BFF737C865368707C0DBBE9F5A62A9B9C79ADF11932A9FA4806210E25C92DB019CC146706DFBC7FA2638ECC4343C1E390426FAA7F2F07FDA163FB5,
# coordinate x of point RA - Imaginary
0x0000000183C9ABF2297CA69699357F58FED92553436BBEBA2C3600D89522E7009D19EA5D6C18CFF993AA3AA33923ED93592B0637ED0B33ADF12388AE912BC4AE4749E2DF3C3292994DCF37747518A992,
# coordinate x of point PB - Real
0x00000001587822E647707ED4313D3BE6A811A694FB201561111838A0816BFB5DEC625D23772DE48A26D78C04EEB26CA4A571C67CE4DC4C620282876B2F2FC2633CA548C3AB0C45CC991417A56F7FEFEB,
# coordinate x of point PB - Imaginary
0x0,
# coordinate x of point QB - Real
0x000000014E647CB19B7EAAAC640A9C26B9C26DB7DEDA8FC9399F4F8CE620D2B2200480F4338755AE16D0E090F15EA1882166836A478C6E161C938E4EB8C2DD779B45FFDD17DCDF158AF48DE126B3A047,
# coordinate x of point QB - Imaginary
0x0,
# coordinate x of point RB - Real
0x00000001DB73BC2DE666D24E59AF5E23B79251BA0D189629EF87E56C38778A448FACE312D08EDFB876C3FD45ECF3746D96E2CADBBA08B1A206C47DDD93137059E34C90E2E42E10F30F6E5F52DED74222,
# coordinate x of point RB - Imaginary
0x00000001B2C30180DAF5D91871555CE8EFEC76A4D521F877B754311228C7180A3E2318B4E7A00341FF99F34E35BF7A1053CA76FD77C0AFAE38E2091862AB4F1DD4C8D9C83DE37ACBA6646EDB4C238B48,
# splits Alice
[67, 37, 21, 12, 7, 4, 2, 1, 1, 2, 1, 1, 3, 2, 1, 1, 1, 1, 5, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 9, 5, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 4, 2, 1, 1, 1, 2, 1, 1, 16, 9, 5, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 4, 2, 1, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 33, 16, 8, 5, 2, 1, 1, 1, 2, 1, 1, 1, 4, 2, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 16, 8, 4, 2, 1, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1 ],
# max Alice row
152,
# max Alice points
8,
# splits Bob
[86, 48, 27, 15, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 7, 4, 2, 1, 1, 2, 1, 1, 3, 2, 1, 1, 1, 1, 12, 7, 4, 2, 1, 1, 2, 1, 1, 3, 2, 1, 1, 1, 1, 5, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 21, 12, 7, 4, 2, 1, 1, 2, 1, 1, 3, 2, 1, 1, 1, 1, 5, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 9, 5, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 4, 2, 1, 1, 1, 2, 1, 1, 38, 21, 12, 7, 4, 2, 1, 1, 2, 1, 1, 3, 2, 1, 1, 1, 1, 5, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 9, 5, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 4, 2, 1, 1, 1, 2, 1, 1, 17, 9, 5, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 4, 2, 1, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1],
# max Bob row
192,
# max Bob points
10,
# SIKE SK length, also known as message length
24,
# SIKE shared secret length
24,
],
[
"p751",
# prime constant f
1,
# prime constant ea
2,
# prime constant eb
3,
# prime constant la
372,
# prime constant lb
239,
# coordinate x of point PA - Real
0x00004514F8CC94B140F24874F8B87281FA6004CA5B3637C68AC0C0BDB29838051F385FBBCC300BBB24BFBBF6710D7DC8B29ACB81E429BD1BD5629AD0ECAD7C90622F6BB801D0337EE6BC78A7F12FDCB09DECFAE8BFD643C89C3BAC1D87F8B6FA,
# coordinate x of point PA - Imaginary
0x0000158ABF500B5914B3A96CED5FDB37D6DD925F2D6E4F7FEA3CC16E1085754077737EA6F8CC74938D971DA289DCF2435BCAC1897D2627693F9BB167DC01BE34AC494C60B8A0F65A28D7A31EA0D54640653A8099CE5A84E4F0168D818AF02041,
# coordinate x of point QA - Real
0x00001723D2BFA01A78BF4E39E3A333F8A7E0B415A17F208D3419E7591D59D8ABDB7EE6D2B2DFCB21AC29A40F837983C0F057FD041AD93237704F1597D87F074F682961A38B5489D1019924F8A0EF5E4F1B2E64A7BA536E219F5090F76276290E,
# coordinate x of point QA - Imaginary
0x00002569D7EAFB6C60B244EF49E05B5E23F73C4F44169A7E02405E90CEB680CB0756054AC0E3DCE95E2950334262CC973235C2F87D89500BCD465B078BD0DEBDF322A2F86AEDFDCFEE65C09377EFBA0C5384DD837BEDB710209FBC8DDB8C35C7,
# coordinate x of point RA - Real
0x00006066E07F3C0D964E8BC963519FAC8397DF477AEA9A067F3BE343BC53C883AF29CCF008E5A30719A29357A8C33EB3600CD078AF1C40ED5792763A4D213EBDE44CC623195C387E0201E7231C529A15AF5AB743EE9E7C9C37AF3051167525BB,
# coordinate x of point RA - Imaginary
0x000050E30C2C06494249BC4A144EB5F31212BD05A2AF0CB3064C322FC3604FC5F5FE3A08FB3A02B05A48557E15C992254FFC8910B72B8E1328B4893CDCFBFC003878881CE390D909E39F83C5006E0AE979587775443483D13C65B107FADA5165,
# coordinate x of point PB - Real
0x0000605D4697A245C394B98024A5554746DC12FF56D0C6F15D2F48123B6D9C498EEE98E8F7CD6E216E2F1FF7CE0C969CCA29CAA2FAA57174EF985AC0A504260018760E9FDF67467E20C13982FF5B49B8BEAB05F6023AF873F827400E453432FE,
# coordinate x of point PB - Imaginary
0x0,
# coordinate x of point QB - Real
0x00005BF9544781803CBD7E0EA8B96D934C5CBCA970F9CC327A0A7E4DAD931EC29BAA8A854B8A9FDE5409AF96C5426FA375D99C68E9AE714172D7F04502D45307FA4839F39A28338BBAFD54A461A535408367D5132E6AA0D3DA6973360F8CD0F1,
# coordinate x of point QB - Imaginary
0x0,
# coordinate x of point RB - Real
0x000055E5124A05D4809585F67FE9EA1F02A06CD411F38588BB631BF789C3F98D1C3325843BB53D9B011D8BD1F682C0E4D8A5E723364364E40DAD1B7A476716AC7D1BA705CCDD680BFD4FE4739CC21A9A59ED544B82566BF633E8950186A79FE3,
# coordinate x of point RB - Imaginary
0x00005AC57EAFD6CC7569E8B53A148721953262C5B404C143380ADCC184B6C21F0CAFE095B7E9C79CA88791F9A72F1B2F3121829B2622515B694A16875ED637F421B539E66F2FEF1CE8DCEFC8AEA608055E9C44077266AB64611BF851BA06C821,
# splits Alice
[80, 48, 27, 15, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 7, 4, 2, 1, 1, 2, 1, 1, 3, 2, 1, 1, 1, 1, 12, 7, 4, 2, 1, 1, 2, 1, 1, 3, 2, 1, 1, 1, 1, 5, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 21, 12, 7, 4, 2, 1, 1, 2, 1, 1, 3, 2, 1, 1, 1, 1, 5, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 9, 5, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 4, 2, 1, 1, 1, 2, 1, 1, 33, 20, 12, 7, 4, 2, 1, 1, 2, 1, 1, 3, 2, 1, 1, 1, 1, 5, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 8, 5, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 4, 2, 1, 1, 2, 1, 1, 16, 8, 4, 2, 1, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1],
# max Alice row
186,
# max Alice points
8,
# splits Bob
[112, 63, 32, 16, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 16, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 31, 16, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 15, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 7, 4, 2, 1, 1, 2, 1, 1, 3, 2, 1, 1, 1, 1, 49, 31, 16, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 15, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 7, 4, 2, 1, 1, 2, 1, 1, 3, 2, 1, 1, 1, 1, 21, 12, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 5, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 9, 5, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 4, 2, 1, 1, 1, 2, 1, 1],
# max Bob row
239,
# max Bob points
10,
# SIKE SK length, also known as message length
32,
# SIKE shared secret length
32,
],
[
"p964",
# prime constant f
1,
# prime constant ea
2,
# prime constant eb
3,
# prime constant la
486,
# prime constant lb
301,
# coordinate x of point PA - Real
0x68bef5878630cacfeae7a298e819599beb99b10302b182af578b391e5cda524b118309bab2e1bf4309791cae8da4c5cde3b7b4250ed70142e9f7c0d1372827364cc48dd8f0259eaab40ed0ada021d7da417580420eb7549d557ee61efcc10f37ddc3966e713688864cc039407826bb88f8f8ac8fe05c4f3c7,
# coordinate x of point PA - Imaginary
0x485fb8aafa5e3911e8a37afa878d64f50992e871f319896628fcb3ebbc1d26612865da8421149194fc71276b24a74e1b7d419fc69ed8af12265c453122cdb82383074531903d08df90cb2949c7628a2610415e72ed7655875ba6647601d0b2807eee627bb34810ec216f0219d926118d92f17e93ad6121c38,
# coordinate x of point QA - Real
0x7e8b1ede7beae1754fb0a85628976a6f005ade35e5ff571708d24f64ffa84fbd401460b6c33ea875aca78db174f13e60d7ac89fc272dc0983a688df6efdb3868a8997dd8904604eaecc8e3d84ce3824d9068a5a724682b5e451d8f013b907da2f5bb525b14e9048e0852e5b698f8257495e41fb10e906c286,
# coordinate x of point QA - Imaginary
0x642356fec8a2b492e288552e1fee2361bb693e6b06c913c409a25dace870e1744735c9adb5db19ad38a9acbe6cf7fe6b494624a0e7625961a4f429fe7ec299721edb10979aee619e4c053425958e411b7534ac07a116c47ad231121f467119058ab7e956a307895a2b69da9bc74957090bceaf5af890243bb,
# coordinate x of point RA - Real
0x1608bb0c053e0ade53496ecab043f175afc0e3c220d6554bd76b6993ef0244eab975235d9acc5df2cd9884b79fba39459a3f1378d6f9e38bf41d9c5e9da7b36c80843f2041911185d4dfe6c354119449f9b2939ccfc9a1da114811151dfe8462621231241c6cae3af1963ec0d0106c81c03e4f84eb4f4744c,
# coordinate x of point RA - Imaginary
0x124e20052856af1cf5b9e703d8adba71c1e16a347ef81e89cebed9193288397fa9eaa65988e7d9c8a0062c40dff84652672fee2da8ea7999da4d8027c230110e670b6500e77f922e580836561abce09267cd2570dc483728ae68987ee62d1e1fe3cc6201c41bdb3b0b4a8a250e3a58a4998b25551ae1bd6d4,
# coordinate x of point PB - Real
0x1be3eb6a2ae87afe407b460477b8ba71bc5803c17192c1196b42bc25641d1fc7b1ab309c5f35bc6ffc640aaea99a9d483a4e518e3a3e9b5047aa234b999715fd3cfdc7bec233e0416ab93cc9d7a7a4e8cb0d6dd5f5f1941916bec1789c8971ce5ac427e0c1a58cf2977cbccd6ac35cefe18f0136d786b75a4,
# coordinate x of point PB - Imaginary
0x0,
# coordinate x of point QB - Real
0x804d52906d63c6a0e62f3cdecfc302e45eb77c0d5da00dd7f370b9985db1e305f05fd0936a020ca9c0451c959fb43668cfafb8bacf31b9aeec4196bfd04a390a725e30a3e5c69ea95f8bcf77bf2706186fec41aa60c24a143d40bebacdcb2e599e77e9b96311744ed07cbc9fa58466b66afdda9afcbf2339,
# coordinate x of point QB - Imaginary
0x0,
# coordinate x of point RB - Real
0x5870a37b0a265936d2c7888fc5f0a680662ad048ec48c97a1fc0a566bfc90fb2699a6f0129aa5990ef3ff37b16e6926249bcb9bfeac0573d5dd43e47fd1db4b39df9e6b85db757595a29319a74174db4abce551ddf3fdc0b3488f05f1b1d4c90c9de7c649a5703342b9bdddee9b7155e7bbdd25951910a370,
# coordinate x of point RB - Imaginary
0x83294bd875073a5dc2373312e0bf8ece4130c32edc320bb53e4ebabac7e243fdc5a69d995f0ef01ea15f947b4f1dbe377e9d1c6ae1f9f539fdb78cd3be150d8eee2a89f43e06c51adf2c909c15a82c2c362bf94e4548e1df2f8e99a0cfc19f41285e91af33e850ce208b34141335f4a4758376baa7b659606,
# splits Alice
[116, 63, 32, 16, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 16, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 31, 16, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 15, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 7, 4, 2, 1, 1, 2, 1, 1, 3, 2, 1, 1, 1, 1, 53, 31, 16, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 15, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 7, 4, 2, 1, 1, 2, 1, 1, 3, 2, 1, 1, 1, 1, 22, 15, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 7, 4, 2, 1, 1, 2, 1, 1, 3, 2, 1, 1, 1, 1, 9, 5, 4, 2, 1, 1, 2, 1, 1, 2, 1, 1, 1, 4, 2, 1, 1, 1, 2, 1, 1],
# max Alice row
243,
# max Alice points
10,
# splits Bob
[136, 71, 38, 25, 15, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 7, 4, 2, 1, 1, 2, 1, 1, 3, 2, 1, 1, 1, 1, 10, 7, 4, 2, 1, 1, 2, 1, 1, 3, 2, 1, 1, 1, 1, 4, 2, 2, 1, 1, 1, 2, 1, 1, 17, 9, 5, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 4, 2, 1, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 33, 17, 9, 5, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 4, 2, 1, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 16, 8, 4, 2, 1, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 65, 33, 17, 9, 5, 3, 2, 1, 1, 1, 1, 2, 1, 1, 1, 4, 2, 1, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 16, 8, 4, 2, 1, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 32, 16, 8, 4, 2, 1, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 16, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1, 8, 4, 2, 1, 1, 2, 1, 1, 4, 2, 1, 1, 2, 1, 1],
# max Bob row
301,
# max Bob points
12,
# SIKE SK length, also known as message length
32,
# SIKE shared secret length
32,
]
]
