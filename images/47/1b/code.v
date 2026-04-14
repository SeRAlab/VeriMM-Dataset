module top_module(
    input [2:0] data_in,
    input sel,
    input clk,
    input reset,
    input enable,
    output reg out
);reg [2:0] data_reg;
    wire sel_inv;
    
    assign sel_inv = ~sel;
    
    always @ (posedge clk, negedge reset)
    begin
        if (!reset) begin
            data_reg <= 3'b0;
            out <= 1'b0;
        end
        else if (enable) begin
            data_reg <= data_in;
            if (sel) begin
                out <= data_reg[sel-1];
            end
            else begin
                out <= data_reg[2];
            end
        end
    end

endmodule