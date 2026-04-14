module register_16bit(
    input        clk,
    input        clear,
    input  [15:0] data_in,
    output reg [15:0] data_out
);

// Register logic
always @(posedge clk or posedge clear) begin
    if (clear)
        data_out <= 16'b0;
    else
        data_out <= data_in;
end

endmodule