module top_module(
    input clk, reset, valid_i, lchar_i,
    input [7:0] dat_i,
    output reg d, s, ready_o
);reg [7:0] data_reg;
reg parity_reg;
reg [2:0] state_reg;

parameter IDLE = 3'b000;
parameter PARITY = 3'b001;
parameter DATA = 3'b010;
parameter DONE = 3'b011;

assign ready_o = (state_reg == IDLE);

always @(posedge clk) begin
    if (reset) begin
        state_reg <= IDLE;
        d <= 1'b0;
        s <= 1'b0;
        data_reg <= 8'h00;
        parity_reg <= 1'b0;
    end else begin
        case (state_reg)
            IDLE: begin
                if (valid_i) begin
                    state_reg <= PARITY;
                    parity_reg <= 1'b0;
                    data_reg <= dat_i;
                end
            end
            PARITY: begin
                s <= 1'b1;
                d <= parity_reg;
                state_reg <= DATA;
            end
            DATA: begin
                s <= 1'b0;
                d <= data_reg[0];
                data_reg <= {data_reg[6:0], parity_reg, data_reg[7]};
                parity_reg <= parity_reg ^ d;
                if (lchar_i) begin
                    state_reg <= PARITY;
                    parity_reg <= 1'b0;
                end else if (!valid_i) begin
                    state_reg <= DONE;
                end
            end
            DONE: begin
                s <= 1'b0;
                d <= 1'b0;
                state_reg <= IDLE;
            end
        endcase
    end
end

endmodule