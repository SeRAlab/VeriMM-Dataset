module deserializer (
    input clk,
    input rst,
    input [1:0] din,
    output reg [15:0] dout
);
    reg [3:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dout <= 16'b0;
            count <= 4'b0;
        end else if (count < 8) begin
            dout <= {dout[13:0], din}; // Shift in 2 bits
            count <= count + 1;
        end
    end
endmodule