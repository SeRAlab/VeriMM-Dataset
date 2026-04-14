module top_module( 
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor,
    output reg [7:0] final_out
);// 2-level AND-OR circuit
    wire [1:0] and_out;
    assign and_out[0] = in[0] & in[1];
    assign and_out[1] = in[2] & in[3];
    assign out_and = and_out[0] | and_out[1];
    
    // 2-level OR-AND circuit
    wire [1:0] or_out;
    assign or_out[0] = in[0] | in[1];
    assign or_out[1] = in[2] | in[3];
    assign out_or = or_out[0] & or_out[1];
    
    // 2-level XOR-AND circuit
    wire [1:0] xor_out;
    assign xor_out[0] = in[0] ^ in[1];
    assign xor_out[1] = in[2] ^ in[3];
    assign out_xor = xor_out[0] & xor_out[1];
    
    // Final output
    always @* begin
        final_out = {1'b0, out_and, out_or, out_xor};
    end
    
endmodule