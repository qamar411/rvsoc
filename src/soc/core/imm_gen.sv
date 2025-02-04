module imm_gen (
    input logic [31:0] inst,
    input logic j_type, 
    input logic b_type, 
    input logic s_type, 
    input logic lui, 
    input logic auipc, 

    output logic [31:0] imm
);

    logic u_type;
    assign u_type = lui | auipc;
    logic i_type;
    assign i_type = ~(j_type | b_type | s_type | u_type);


    // IMM[0]
    one_hot_mux2x1 #(
        .n(1)
    ) imm_0_mux (
        .sel({s_type, i_type}),
        .in1(inst[7]),
        .in0(inst[20]),
        .out(imm[0])
    );

    // IMM[4:1]
    logic [4:1] temp_imm;
    one_hot_mux2x1 #(
        .n(4)
    ) imm_4_to_1_mux (
        .sel({(j_type | i_type),(b_type | s_type)}),
        .in1(inst[24:21]),
        .in0(inst[11:8]),
        .out(temp_imm[4:1])
    );
    assign imm[4:1] = temp_imm & ~({4{u_type}});


    // IMM[10:5]
    assign imm[10:5] = inst[30:25] & ~({6{u_type}});

   
    // IMM[31] the MSB
    assign imm[31] = inst[31];
    
    
    // IMM[12:19]
    mux2x1 #(
        .n(8)
    ) imm_19_to_12_mux (
        .sel((u_type | j_type)),
        .in0({8{imm[31]}}),
        .in1(inst[19:12]),
        .out(imm[19:12])
    );


    // IMM[30:20]
    mux2x1 #(
        .n(11)
    ) imm_30_to_20_mux (
        .sel(u_type),
        .in0({11{imm[31]}}),
        .in1(inst[30:20]),
        .out(imm[30:20])
    );


    // IMM[11]
    one_hot_mux3x1 #(
        .n(1)
    ) imm_11_mux (
        .sel({(i_type|s_type), b_type, j_type}),
        .in2(imm[31]),
        .in1(inst[7]),
        .in0(inst[20]),
        .out(imm[11])
    );

endmodule 