module top_module(
    input clk,
    input reset,
    input [3:0] in,
    output reg pulse,
    output reg [3:0] edge_detect
);reg [1:0] even_cnt;
reg [1:0] odd_cnt;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        even_cnt <= 2'b00;
        odd_cnt <= 2'b00;
        pulse <= 1'b0;
        edge_detect <= 4'b0000;
    end else begin
        if (in[0] == 1'b0) begin
            edge_detect[0] <= 1'b1;
        end
        if (in[1] == 1'b0) begin
            edge_detect[1] <= 1'b1;
        end
        if (in[2] == 1'b0) begin
            edge_detect[2] <= 1'b1;
        end
        if (in[3] == 1'b0) begin
            edge_detect[3] <= 1'b1;
        end
        
        if (even_cnt == 2'b00 && in[0] == 1'b0 && in[1] == 1'b0) begin
            even_cnt <= 2'b01;
        end else if (even_cnt == 2'b01 && in[0] == 1'b1 && in[1] == 1'b1) begin
            even_cnt <= 2'b10;
        end else if (even_cnt == 2'b10 && in[2] == 1'b0 && in[3] == 1'b0) begin
            even_cnt <= 2'b11;
        end else if (even_cnt == 2'b11 && in[2] == 1'b1 && in[3] == 1'b1) begin
            pulse <= 1'b1;
            even_cnt <= 2'b00;
            odd_cnt <= 2'b00;
        end else begin
            even_cnt <= 2'b00;
        end
        
        if (odd_cnt == 2'b00 && in[0] == 1'b1 && in[1] == 1'b1) begin
            odd_cnt <= 2'b01;
        end else if (odd_cnt == 2'b01 && in[0] == 1'b0 && in[1] == 1'b0) begin
            odd_cnt <= 2'b10;
        end else if (odd_cnt == 2'b10 && in[2] == 1'b1 && in[3] == 1'b1) begin
            odd_cnt <= 2'b11;
        end else if (odd_cnt == 2'b11 && in[2] == 1'b0 && in[3] == 1'b0) begin
            pulse <= 1'b1;
            even_cnt <= 2'b00;
            odd_cnt <= 2'b00;
        end else begin
            odd_cnt <= 2'b00;
        end
    end
end

endmodule