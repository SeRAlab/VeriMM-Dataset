module shift_register(
    input clk,
    input reset,
    input shift_dir,
    input data_in,
    output reg [7:0] shift_out
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            shift_out <= 8'd0;
        else if (shift_dir)
            shift_out <= {shift_out[6:0], data_in}; // Shift left
        else
            shift_out <= {data_in, shift_out[7:1]}; // Shift right
    end
endmodule