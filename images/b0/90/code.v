module top_module(
    input clk,
    input [3:0] col,
    output reg [3:0] row
);reg [3:0] row_pipe1, row_pipe2, row_pipe3;

always @(posedge clk) begin
    row_pipe1 <= row;
    row_pipe2 <= row_pipe1;
    row_pipe3 <= row_pipe2;
    
    if (col == 4'b1110) begin
        row <= 4'b1110;
    end
    else if (col == 4'b1101) begin
        row <= 4'b1101;
    end
    else if (col == 4'b1011) begin
        row <= 4'b1011;
    end
    else if (col == 4'b0111) begin
        row <= 4'b0111;
    end
    else begin
        row <= 4'b0000;
    end
end

assign row1 = row_pipe3[0];
assign row2 = row_pipe3[1];
assign row3 = row_pipe3[2];
assign row4 = row_pipe3[3];

endmodule