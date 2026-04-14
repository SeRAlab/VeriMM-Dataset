module top_module(
    input clk,
    input rst_n,
    input [15:0] in,
    output reg rise,
    output reg down,
    output reg [7:0] out_hi,
    output reg [7:0] out_lo,
    output reg [7:0] final_out
);reg [15:0] input_reg;
    reg [7:0] hi_reg;
    reg [7:0] lo_reg;
    reg [1:0] state;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 2'b00;
            input_reg <= 16'h0000;
            hi_reg <= 8'h00;
            lo_reg <= 8'h00;
            rise <= 1'b0;
            down <= 1'b0;
            out_hi <= 8'h00;
            out_lo <= 8'h00;
            final_out <= 8'h00;
        end else begin
            input_reg <= in;
            case (state)
                2'b00: begin
                    if (input_reg[0] == 1'b1) begin
                        rise <= 1'b1;
                        state <= 2'b01;
                    end else if (input_reg[0] == 1'b0) begin
                        down <= 1'b1;
                        state <= 2'b10;
                    end
                end
                2'b01: begin
                    rise <= 1'b0;
                    state <= 2'b10;
                end
                2'b10: begin
                    down <= 1'b0;
                    state <= 2'b00;
                end
            endcase
            hi_reg <= input_reg[15:8];
            lo_reg <= input_reg[7:0];
            out_hi <= hi_reg;
            out_lo <= lo_reg;
            final_out <= hi_reg | lo_reg | rise | down;
        end
    end

endmodule