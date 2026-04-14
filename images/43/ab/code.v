module top_module(
    input clk,
    input reset,
    input control,
    output reg [2:0] count,
    output reg [7:0] gray_out,
    output reg [7:0] sum_out
);reg [2:0] count_reg;
    reg [2:0] count_next;
    reg [2:0] count_gray;
    
    always @(posedge clk or negedge reset) begin
        if (reset == 0) begin
            count_reg <= 3'b000;
        end else begin
            count_reg <= count_next;
        end
    end
    
    always @(*) begin
        if (control == 1) begin
            count_next = count_reg + 1;
        end else begin
            count_next = count_reg - 1;
        end
        
        if (count_reg == 3'b000) begin
            count_gray = 3'b000;
        end else if (count_reg == 3'b001) begin
            count_gray = 3'b001;
        end else if (count_reg == 3'b010) begin
            count_gray = 3'b011;
        end else if (count_reg == 3'b011) begin
            count_gray = 3'b010;
        end else if (count_reg == 3'b100) begin
            count_gray = 3'b110;
        end else if (count_reg == 3'b101) begin
            count_gray = 3'b111;
        end else if (count_reg == 3'b110) begin
            count_gray = 3'b101;
        end else if (count_reg == 3'b111) begin
            count_gray = 3'b100;
        end
    end
    
    assign gray_out = {count_gray[2], count_gray[1] ^ count_gray[2], count_gray[0] ^ count_gray[1]};
    
    always @(*) begin
        sum_out = count + gray_out;
    end
    
endmodule