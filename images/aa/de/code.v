module top_module(output reg [7:0] reg_0x1D, input wire reset, input wire wenb, input wire [7:0] in_data, input wire clk);always@(posedge clk)
    begin
        if(reset==1) begin
            reg_0x1D<=8'h00;
        end
        else if(wenb==1) begin
            reg_0x1D<=in_data;
        end
    end
endmodule