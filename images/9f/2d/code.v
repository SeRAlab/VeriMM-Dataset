module top_module(
    input wire ps2_d_i,
    input wire ps2_c_i,
    input wire reset_i,
    input wire sys_clk_i,
    output reg [7:0] d_o,
    output reg frame_o
);reg [3:0] state;
reg [7:0] data_reg;
reg parity_reg;
reg start_bit;
reg stop_bit;

parameter IDLE = 2'b00;
parameter START = 2'b01;
parameter DATA = 2'b10;
parameter PARITY = 2'b11;

always @(posedge sys_clk_i) begin
    case(state)
        IDLE: begin
            if(!reset_i && !ps2_c_i && ps2_d_i) begin
                state <= START;
                start_bit <= ps2_d_i;
            end
        end
        START: begin
            data_reg <= 0;
            parity_reg <= 0;
            state <= DATA;
        end
        DATA: begin
            data_reg <= {data_reg[6:0], ps2_d_i};
            parity_reg <= parity_reg ^ ps2_d_i;
            if(data_reg == 8'b11111111) begin
                state <= PARITY;
            end
        end
        PARITY: begin
            if(parity_reg == 1'b0) begin
                state <= IDLE;
            end else begin
                state <= START;
            end
        end
    endcase
end

always @(posedge ps2_c_i) begin
    if(state == START && ps2_c_i && !ps2_d_i) begin
        start_bit <= ps2_d_i;
    end else if(state == PARITY && ps2_c_i) begin
        stop_bit <= ps2_d_i;
    end
end

always @(posedge sys_clk_i) begin
    if(state == IDLE && reset_i) begin
        d_o <= 8'b0;
        frame_o <= 0;
    end else if(state == PARITY && stop_bit) begin
        d_o <= data_reg;
        frame_o <= 1;
    end else begin
        frame_o <= 1;
    end
end

endmodule