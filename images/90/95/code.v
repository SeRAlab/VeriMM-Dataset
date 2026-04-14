module top_module(
    input clk,
    input rst,
    input [3:0] in,
    input prior,
    output [1:0] out,
    output valid
);reg [3:0] in_reg;
    reg [1:0] out_reg;
    reg valid_reg;

    always @(posedge clk or negedge rst) begin
        if (rst == 0) begin
            in_reg <= 4'b0;
            out_reg <= 2'b0;
            valid_reg <= 0;
        end else begin
            in_reg <= in;
            valid_reg <= |in; // check if at least one bit is set
            if (prior == 1) begin // highest priority
                casez(in_reg)
                    4'b1000: out_reg <= 2'b11;
                    4'b0100: out_reg <= 2'b10;
                    4'b0010: out_reg <= 2'b01;
                    4'b0001: out_reg <= 2'b00;
                    default: out_reg <= 2'b00;
                endcase
            end else begin // lowest priority
                casez(in_reg)
                    4'b0001: out_reg <= 2'b00;
                    4'b0010: out_reg <= 2'b01;
                    4'b0100: out_reg <= 2'b10;
                    4'b1000: out_reg <= 2'b11;
                    default: out_reg <= 2'b00;
                endcase
            end
        end
    end

    assign out = out_reg;
    assign valid = valid_reg;

endmodule