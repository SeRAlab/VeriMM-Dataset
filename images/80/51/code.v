module register_16bit(
    input clk,
    input set,
    input clear,
    input [15:0] data_in,
    
    output reg [15:0] data_out
);

always @(posedge clk) begin
    if (set) begin
        data_out <= 16'b1111111111111111;
    end else if (clear) begin
        data_out <= 16'b0000000000000000;
    end else begin
        data_out <= data_in;
    end
end

endmodule