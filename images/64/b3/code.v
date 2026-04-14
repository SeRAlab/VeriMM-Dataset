module top_module(input clk, input rst, input [3:0] row, input [3:0] col, output reg [3:0] key, output reg valid);// initialize key and valid outputs to 0
always @(posedge clk, posedge rst) begin
    if (rst) begin
        key <= 4'b0;
        valid <= 1'b0;
    end else begin
        key <= 4'b0;
        valid <= 1'b0;
    end
end

// detect key press
always @(posedge clk) begin
    if (row == 4'b1110) begin
        case (col)
            4'b1101: key <= 4'b0001;
            4'b1110: key <= 4'b0010;
            4'b1111: key <= 4'b0011;
        endcase
        valid <= 1'b1;
    end else if (row == 4'b1101) begin
        case (col)
            4'b1101: key <= 4'b0100;
            4'b1110: key <= 4'b0101;
            4'b1111: key <= 4'b0110;
        endcase
        valid <= 1'b1;
    end else if (row == 4'b1011) begin
        case (col)
            4'b1101: key <= 4'b0111;
            4'b1110: key <= 4'b1000;
            4'b1111: key <= 4'b1001;
        endcase
        valid <= 1'b1;
    end else if (row == 4'b0111) begin
        case (col)
            4'b1101: key <= 4'b1010;
            4'b1110: key <= 4'b1011;
            4'b1111: key <= 4'b1100;
        endcase
        valid <= 1'b1;
    end else begin
        valid <= 1'b0;
    end
end

endmodule