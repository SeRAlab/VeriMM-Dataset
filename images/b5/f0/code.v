module top_module(output reg [7:0] reg_0x1F, input wire reset, input wire wenb, input wire [7:0] in_data, input wire clk);always @(posedge clk) begin
        if (reset == 1'b1) begin
            reg_0x1F <= 8'h00;
        end
        else begin
            if (wenb == 1'b0) begin
                reg_0x1F <= in_data;
            end
            else begin
                reg_0x1F <= reg_0x1F;
            end
        end
    end
endmodule