module counter_32bit (
    input wire clk,
    input wire rst,
    input wire en,
    output reg [31:0] count
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 32'b0;
    end else if (en) begin
        count <= count + 1;
    end
end

endmodule