module sata_controller (
    input clk,
    input reset,
    input start,
    input init_done,
    input data_done,
    output reg [1:0] state
);
    // State encoding
    localparam IDLE = 2'b00;
    localparam INIT = 2'b01;
    localparam DATA = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= INIT;
                    end
                end
                INIT: begin
                    if (init_done) begin
                        state <= DATA;
                    end
                end
                DATA: begin
                    if (data_done) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule