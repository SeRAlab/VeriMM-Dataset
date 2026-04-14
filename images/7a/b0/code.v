module top_module(
    output reg [7:0] reg_0x53, 
    input wire reset, 
    input wire wenb, 
    input wire [7:0] in_data, 
    input wire clk,
    input wire write_enable
);always@(posedge clk)
    begin
        if(reset==1) begin
            reg_0x53<=8'h00;
        end
        else if(write_enable==1) begin
            reg_0x53<=in_data;
        end
        else if(wenb==0) begin
            reg_0x53<=in_data;
        end
    end
endmodule