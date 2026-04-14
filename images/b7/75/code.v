module top_module(
    output reg [7:0] reg_0x29,
    input wire reset,
    input wire wenb,
    input wire [7:0] in_data,
    input wire clk
);always@(posedge clk) begin
    if(reset) begin
        reg_0x29 <= 8'h00;
    end
    else if(!wenb) begin
        reg_0x29 <= in_data;
    end
end

endmodule