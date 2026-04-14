module top_module (
    input clk,
    input d1,
    input d2,
    output q1,
    output q2,
    output xor_output
);

    reg q1_reg, q2_reg;
    wire xor_wire;
    
    always @(posedge clk) begin
        q1_reg <= d1;
        q2_reg <= d2;
    end
    
    assign q1 = q1_reg;
    assign q2 = q2_reg;
    
    xor_gate xor_inst (
        .a(q1_reg),
        .b(q2_reg),
        .xor_output(xor_wire)
    );
    
    assign xor_output = xor_wire;
    
endmodule

module xor_gate (
    input a,
    input b,
    output xor_output
);

    assign xor_output = a ^ b;
    
endmodule