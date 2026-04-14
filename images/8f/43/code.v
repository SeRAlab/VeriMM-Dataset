module top_module(
    input clk,
    input reset,
    input start,
    input stop,
    input [15:0] data,
    output reg recording,
    output reg [15:0] data_out
);reg [15:0] data_reg;
reg [1:0] state;

parameter IDLE = 2'b00, RECORDING = 2'b01, OUTPUTTING = 2'b10;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        recording <= 0;
        data_out <= 0;
        data_reg <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= RECORDING;
                    recording <= 1;
                    data_reg <= data;
                end
            end
            RECORDING: begin
                if (stop) begin
                    state <= OUTPUTTING;
                    recording <= 0;
                end else begin
                    data_reg <= data;
                end
            end
            OUTPUTTING: begin
                if (!stop) begin
                    state <= IDLE;
                    data_out <= data_reg;
                end
            end
        endcase
    end
end

endmodule