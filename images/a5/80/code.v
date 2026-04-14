module top_module(
    input clk,
    input rst_n,
    input sclk,
    input ss,
    input mosi,
    output miso,
    input [15:0] data_in,
    output [15:0] data_out,
    input [1:0] data_length,
    input data_ready,
    output reg data_valid  // Changed from wire to reg
);parameter IDLE = 2'b00;
    parameter TRANSFER = 2'b01;
    parameter COMPLETE = 2'b10;

    reg [1:0] state;
    reg [15:0] shift_reg;
    reg [3:0] bit_count;
    reg [15:0] data;

    assign miso = shift_reg[bit_count];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            shift_reg <= 0;
            bit_count <= 0;
            data <= 0;
            data_valid <= 0;
        end
        else begin
            case (state)
                IDLE: begin
                    if (!ss) begin
                        state <= TRANSFER;
                        shift_reg <= data_in;
                        bit_count <= 0;
                        data <= 0;
                        data_valid <= 0;
                    end
                end
                TRANSFER: begin
                    if (bit_count == (data_length * 8) - 1) begin
                        state <= COMPLETE;
                        data <= shift_reg;
                        data_valid <= 1;
                    end
                    else begin
                        bit_count <= bit_count + 1;
                        shift_reg <= {shift_reg[14:0], mosi};
                    end
                end
                COMPLETE: begin
                    if (ss) begin
                        state <= IDLE;
                        shift_reg <= 0;
                        bit_count <= 0;
                        data <= 0;
                        data_valid <= 0;
                    end
                end
            endcase
        end
    end

    assign data_out = data;

endmodule