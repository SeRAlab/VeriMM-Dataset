module top_module(
    input clk,
    input reset,
    input load,
    input direction,
    input [3:0] data_in,
    output reg [3:0] count
);reg [3:0] count_reg1;
reg [3:0] count_reg2;

always @(posedge clk) begin
    if(reset) begin
        count_reg1 <= 4'b0;
        count_reg2 <= 4'b0;
    end
    else if(load) begin
        count_reg1 <= data_in;
        count_reg2 <= data_in;
    end
    else begin
        count_reg1 <= count_reg2;
        if(direction) begin
            count_reg2 <= count_reg2 + 1;
        end
        else begin
            count_reg2 <= count_reg2 - 1;
        end
    end
end

assign count = count_reg1;

endmodule