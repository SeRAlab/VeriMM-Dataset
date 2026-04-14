module top_module(
    input clk,
    input reset,
    input load,
    input [3:0] data,
    output reg [3:0] count
);reg [3:0] count_reg1, count_reg2;
reg load_reg;

always @(posedge clk) begin
    if(reset) begin
        count_reg1 <= 4'b0;
        count_reg2 <= 4'b0;
        load_reg <= 1'b0;
    end
    else begin
        count_reg1 <= count_reg2;
        count_reg2 <= count;
        load_reg <= load;
    end
end

always @(*) begin
    if(load_reg) begin
        count <= data;
    end
    else begin
        count <= count_reg1 + 4'b1;
    end
end

endmodule