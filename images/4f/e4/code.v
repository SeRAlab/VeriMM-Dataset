module top_module(
    input [3:0] in,
    input a,
    input b,
    input clk,
    input reset,
    output reg final_out
);// First given module
    wire [1:0] and1, and2, or1, or2, xor1, xor2;
    assign and1 = in[0] & in[1];
    assign and2 = in[2] & in[3];
    assign or1 = in[0] | in[1];
    assign or2 = in[2] | in[3];
    assign xor1 = in[0] ^ in[1];
    assign xor2 = in[2] ^ in[3];
    wire out_and, out_or, out_xor;
    assign out_and = and1 & and2;
    assign out_or = or1 | or2;
    assign out_xor = xor1 ^ xor2;

    // Second given module
    reg xor_gate_out;
    always @ (a or b) begin
        case ({a,b})
            2'b00: xor_gate_out = 1'b0;
            2'b01: xor_gate_out = 1'b1;
            2'b10: xor_gate_out = 1'b1;
            2'b11: xor_gate_out = 1'b0;
        endcase
    end

    // Functional module
    always @ (posedge clk, posedge reset) begin
        if (reset) begin
            final_out <= 1'b0;
        end else begin
            final_out <= (out_and & out_or) ^ (out_xor ^ xor_gate_out);
        end
    end

endmodule