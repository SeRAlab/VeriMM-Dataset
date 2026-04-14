module register_16bit(
    input                 clk,
    input                 rst,
    input                 load,
    input  [15:0]         data_in,
    
    output reg [15:0]     data_out
);

// Register implementation
always @(posedge clk) begin
    if (rst)
        data_out <= 16'd0;
    else if (load)
        data_out <= data_in;
end

endmodule