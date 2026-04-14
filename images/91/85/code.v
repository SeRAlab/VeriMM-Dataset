module shift_register_4bit (
        input clk,
        input shift_enable,
        input [3:0] parallel_in,
        output reg [3:0] parallel_out);

    always @(posedge clk) begin
        if (shift_enable)
            parallel_out <= {parallel_out[2:0], 1'b0};
        else
            parallel_out <= parallel_in;
    end

endmodule