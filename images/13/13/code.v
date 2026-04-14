module sample_rate_converter (
    input clk,
    input rst,
    input din,
    output reg [1:0] dout
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dout <= 2'b00;
        end else begin
            dout <= {dout[0], din}; // Shift and load new data
        end
    end
endmodule