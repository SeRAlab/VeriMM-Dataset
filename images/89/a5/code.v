module top_module(
    input clk,
    input rst_n,
    input up_down,
    input [3:0] load_data,
    output reg [3:0] count
);reg [3:0] count_reg1, count_reg2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        count_reg1 <= 4'b0000;
        count_reg2 <= 4'b0000;
    end
    else begin
        count_reg1 <= count_reg2;
        count_reg2 <= count;
    end
end

always @(*) begin
    if (up_down) begin
        if (load_data != 4'b0000) begin
            count = load_data;
        end
        else begin
            count = count_reg1 + 4'b0001;
        end
    end
    else begin
        if (load_data != 4'b0000) begin
            count = load_data;
        end
        else begin
            count = count_reg1 - 4'b0001;
        end
    end
end

endmodule