module top_module(
    input [7:0] a,
    input [7:0] b,
    input [4:0] shift_amount,
    output [15:0] final_output,
    output zero_flag
);// Carry-lookahead adder
    wire [8:0] carry;
    wire [8:0] sum;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : cla
            assign carry[i+1] = (a[i] & b[i]) | (a[i] & carry[i]) | (b[i] & carry[i]);
            assign sum[i] = a[i] ^ b[i] ^ carry[i];
        end
    endgenerate

    // Full adder
    wire carry_out;
    wire signed_overflow;
    assign carry_out = carry[8];
    assign signed_overflow = (a[7] == b[7]) && (a[7] != sum[7]);

    // Barrel shifter
    wire [15:0] shifted_output;
    assign shifted_output = (shift_amount[4]) ? {8'b0, sum} >> shift_amount[3:0] : sum << shift_amount[3:0];
    assign zero_flag = (shifted_output == 16'h0000);

    // Final output
    assign final_output = {signed_overflow, shifted_output};

endmodule