module rom (
    input logic [11:0] addr, 
    output logic [31:0] inst
);

   logic [31:0] rom [0:127];

//    initial  $readmemh("tb/uart_receiver/rom.hex",imem);

        assign rom[0]    = 32'h1FC00113;
        assign rom[1]    = 32'h00000413;
        assign rom[2]    = 32'h20000493;
        assign rom[3]    = 32'h00000317;
        assign rom[4]    = 32'h0A4300E7;
        assign rom[5]    = 32'h00000317;
        assign rom[6]    = 32'h114300E7;
        assign rom[7]    = 32'h20A40023;
        assign rom[8]    = 32'h00A40023;
        assign rom[9]    = 32'h20044503;
        assign rom[10]   = 32'h00044583;
        assign rom[11]   = 32'h00851513;
        assign rom[12]   = 32'h00B56533;
        assign rom[13]   = 32'h00000317;
        assign rom[14]   = 32'h0D8300E7;
        assign rom[15]   = 32'h00140413;
        assign rom[16]   = 32'hFC9416E3;
        assign rom[17]   = 32'h0000B537;
        assign rom[18]   = 32'hAAA50513;
        assign rom[19]   = 32'h00000317;
        assign rom[20]   = 32'h0C0300E7;
        assign rom[21]   = 32'h00000317;
        assign rom[22]   = 32'h0EC300E7;
        assign rom[23]   = 32'h00005537;
        assign rom[24]   = 32'h55550513;
        assign rom[25]   = 32'h00000317;
        assign rom[26]   = 32'h0A8300E7;
        assign rom[27]   = 32'h00000317;
        assign rom[28]   = 32'h0D4300E7;
        assign rom[29]   = 32'h0000B537;
        assign rom[30]   = 32'hAAA50513;
        assign rom[31]   = 32'h00000317;
        assign rom[32]   = 32'h090300E7;
        assign rom[33]   = 32'h00000317;
        assign rom[34]   = 32'h0BC300E7;
        assign rom[35]   = 32'h00005537;
        assign rom[36]   = 32'h55550513;
        assign rom[37]   = 32'h00000317;
        assign rom[38]   = 32'h078300E7;
        assign rom[39]   = 32'h00000317;
        assign rom[40]   = 32'h0A4300E7;
        assign rom[41]   = 32'h20000293;
        assign rom[42]   = 32'h00028067;
        assign rom[43]   = 32'h00000063;
        assign rom[44]   = 32'h40000293;
        assign rom[45]   = 32'h08000313;
        assign rom[46]   = 32'h00628623;
        assign rom[47]   = 32'h01B00313;
        assign rom[48]   = 32'h00628023;
        assign rom[49]   = 32'h00306313;
        assign rom[50]   = 32'h00036313;
        assign rom[51]   = 32'h00036313;
        assign rom[52]   = 32'h00628623;
        assign rom[53]   = 32'h00106313;
        assign rom[54]   = 32'h00036313;
        assign rom[55]   = 32'h08036313;
        assign rom[56]   = 32'h00236313;
        assign rom[57]   = 32'h00436313;
        assign rom[58]   = 32'h00628423;
        assign rom[59]   = 32'h00028223;
        assign rom[60]   = 32'h00008067;
        assign rom[61]   = 32'h40000313;
        assign rom[62]   = 32'h01430283;
        assign rom[63]   = 32'h0202F293;
        assign rom[64]   = 32'hFE028AE3;
        assign rom[65]   = 32'h00A30023;
        assign rom[66]   = 32'h00008067;
        assign rom[67]   = 32'h42000293;
        assign rom[68]   = 32'h00010337;
        assign rom[69]   = 32'hFFF30313;
        assign rom[70]   = 32'h0062A423;
        assign rom[71]   = 32'h00A2A223;
        assign rom[72]   = 32'h0002A583;
        assign rom[73]   = 32'h00008067;
        assign rom[74]   = 32'h40000313;
        assign rom[75]   = 32'h01430283;
        assign rom[76]   = 32'h0012F293;
        assign rom[77]   = 32'hFE028AE3;
        assign rom[78]   = 32'h00030503;
        assign rom[79]   = 32'h00008067;
        assign rom[80]   = 32'h00000293;
        assign rom[81]   = 32'h01C9C337;
        assign rom[82]   = 32'h38030313;
        assign rom[83]   = 32'h00128293; 
        assign rom[84]   = 32'hFE629EE3;
        assign rom[85]   = 32'h00008067;
        assign rom[86]   = 32'h00000593;
        assign rom[87]   = 32'h00008913;
        assign rom[88]   = 32'h00000317;
        assign rom[89]   = 32'hFE0300E7;
        assign rom[90]   = 32'h00158593;
        assign rom[91]   = 32'hFEA59AE3;
        assign rom[92]   = 32'h00090093;
        assign rom[93]   = 32'h00008067;
        assign rom[94]   = 32'h00158593;
        assign rom[95]   = 32'hFEA59AE3;
        assign rom[96]   = 32'h00090093;
        assign rom[97]   = 32'h00008067;
        assign rom[98]   = 32'h00000317;
        assign rom[99]   = 32'hFE0300E7;
        assign rom[100]  = 32'h00158593;
        assign rom[101]  = 32'hFEA59AE3;
        assign rom[102]  = 32'h00090093;
        assign rom[103]  = 32'h00008067;
        assign rom[104]  = 32'h00090093;
        assign rom[105]  = 32'h00008067;
        assign rom[106]  = 32'h00000293;
        assign rom[107]  = 32'h01C9C337;
        assign rom[108]  = 32'h38030313;
        assign rom[109]  = 32'h00128293;
        assign rom[110]  = 32'hFE629EE3;
        assign rom[111]  = 32'h00008067;
        assign rom[112]  = 32'h00000000;
        assign rom[113]  = 32'h00000000;
        assign rom[114]  = 32'h00000000;
        assign rom[115]  = 32'h00000000;
        assign rom[116]  = 32'h00000000;
        assign rom[117]  = 32'h00000000;
        assign rom[118]  = 32'h00000000;
        assign rom[119]  = 32'h00000000;
        assign rom[120]  = 32'h00000000;
        assign rom[121]  = 32'h00000000;
        assign rom[122]  = 32'h00000000;
        assign rom[123]  = 32'h00000000;
        assign rom[124]  = 32'h00000000;
        assign rom[125]  = 32'h00000000;
        assign rom[126]  = 32'h00000000;
        assign rom[127]  = 32'h00000000;

    assign inst = rom[addr >> 2];
endmodule























































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































