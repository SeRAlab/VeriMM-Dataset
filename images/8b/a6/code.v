module top_module(
    input sys_clk,
    input [7:0] data_in,
    input start,
    input ready,
    output reg tx,
    output reg done
);reg [3:0] state;
    reg [7:0] shift_reg;
    reg bit_count;

    parameter IDLE = 2'b00;
    parameter START_BIT = 2'b01;
    parameter DATA_BITS = 2'b10;
    parameter STOP_BIT = 2'b11;

    always @(posedge sys_clk) begin
        case(state)
            IDLE: begin
                if(start && ready) begin
                    shift_reg <= data_in;
                    bit_count <= 0;
                    tx <= 0;
                    done <= 0;
                    state <= START_BIT;
                end
            end
            START_BIT: begin
                tx <= 0;
                if(bit_count == 8) begin
                    bit_count <= 0;
                    state <= STOP_BIT;
                end else begin
                    bit_count <= bit_count + 1;
                    state <= DATA_BITS;
                end
            end
            DATA_BITS: begin
                tx <= shift_reg[0];
                shift_reg <= {shift_reg[6:0], 1'b0};
                if(bit_count == 8) begin
                    bit_count <= 0;
                    state <= STOP_BIT;
                end else begin
                    bit_count <= bit_count + 1;
                end
            end
            STOP_BIT: begin
                tx <= 1;
                done <= 1;
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end

endmodule