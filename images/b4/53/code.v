module top_module(
    input clk,
    input up_down,
    input load,
    output reg [2:0] count
);reg [2:0] count_reg1;
reg [2:0] count_reg2;

always @(posedge clk) begin
    if (load) begin
        count_reg1 <= 3'b0;
        count_reg2 <= 3'b0;
    end else begin
        count_reg1 <= count_reg2;
        count_reg2 <= count;
    end
end

always @(*) begin
    if (up_down) begin
        count = count_reg1 + 3'b001;
    end else begin
        count = count_reg1 - 3'b001;
    end
end

endmodule