module sata_controller(
    input wire clk,
    input wire reset,
    input wire start,
    input wire init_done,
    input wire transfer_done,
    output reg [1:0] state
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam INIT = 2'b01;
    localparam TRANSFER = 2'b10;
    localparam DONE = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) state <= INIT;
                end
                INIT: begin
                    if (init_done) state <= TRANSFER;
                end
                TRANSFER: begin
                    if (transfer_done) state <= DONE;
                end
                DONE: begin
                    state <= IDLE; // go back to IDLE after done
                end
            endcase
        end
    end
endmodule