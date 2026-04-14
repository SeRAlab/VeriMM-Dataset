module NVMe_Controller (
    input clk,
    input reset,
    input start,
    input rw, // rw = 0 for READ, rw = 1 for WRITE
    output reg [1:0] state // 00: IDLE, 01: READ, 10: WRITE
);

    // State encoding
    localparam IDLE  = 2'b00;
    localparam READ  = 2'b01;
    localparam WRITE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        if (rw) 
                            state <= WRITE;
                        else 
                            state <= READ;
                    end
                end
                READ: begin
                    if (!start) 
                        state <= IDLE;
                end
                WRITE: begin
                    if (!start) 
                        state <= IDLE;
                end
            endcase
        end
    end
endmodule