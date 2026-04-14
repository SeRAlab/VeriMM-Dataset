module shift_register_8bit(
    input                 clk,
    input                 rst,
    input                 load,
    input [7:0]           data_in,
    input                 shift_left,
    input                 shift_right,
    
    output reg [7:0]      data_out
);

// Shift register implementation
always @(posedge clk) begin
    if (rst)
        data_out <= 8'd0;
    else if (load)
        data_out <= data_in;
    else if (shift_left)
        data_out <= data_out << 1;
    else if (shift_right)
        data_out <= data_out >> 1;
end

endmodule