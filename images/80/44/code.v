module top_module(
    input clk,
    input rst,
    input load,
    input up_down,
    input [2:0] data_in,
    output reg [2:0] count
);reg [2:0] count_reg1, count_reg2;
reg [1:0] stage;

always @(posedge clk) begin
    if (rst) begin
        count_reg1 <= 3'b0;
        count_reg2 <= 3'b0;
        stage <= 2'b00;
    end
    else begin
        case (stage)
            2'b00: begin
                count_reg1 <= count;
                if (load) begin
                    count_reg2 <= data_in;
                    stage <= 2'b01;
                end
                else if (up_down) begin
                    count_reg2 <= count_reg1 + 3'b1;
                    stage <= 2'b10;
                end
                else begin
                    count_reg2 <= count_reg1 - 3'b1;
                    stage <= 2'b10;
                end
            end
            2'b01: begin
                count_reg2 <= count_reg2;
                stage <= 2'b10;
            end
            2'b10: begin
                count_reg1 <= count_reg2;
                stage <= 2'b00;
            end
        endcase
    end
end

assign count = count_reg1;

endmodule