module top_module(
    input [3:0] in1,    // First 4-bit input for the multiplexer
    input [3:0] in2,    // Second 4-bit input for the multiplexer
    input sel1,         // First select input for the multiplexer
    input sel2,         // Second select input for the multiplexer
    output reg [3:0] mux_out,   // 4-bit output from the multiplexer, changed to reg
    input [3:0] comp_in1,   // First 4-bit input for the comparator
    input [3:0] comp_in2,   // Second 4-bit input for the comparator
    output eq_out,      // 1-bit output indicating if the two inputs are equal
    output gt_out,      // 1-bit output indicating if the first input is greater than the second input
    output lt_out       // 1-bit output indicating if the first input is less than the second input
);// 2-to-1 multiplexer
    always @(*) begin
        if (sel1 & sel2) begin
            mux_out = in2;
        end else begin
            mux_out = in1;
        end
    end

    // 4-bit binary comparator
    assign eq_out = (comp_in1 == comp_in2);
    assign gt_out = (comp_in1 > comp_in2);
    assign lt_out = (comp_in1 < comp_in2);

endmodule