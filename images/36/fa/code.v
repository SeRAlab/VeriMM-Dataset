module nvme_controller (
    input clk,
    input reset,
    input start,
    input done,
    output reg [1:0] state // 00: IDLE, 01: READ, 10: WRITE
);

    // State encoding
    localparam IDLE  = 2'b00;
    localparam READ  = 2'b01;
    localparam WRITE = 2'b10;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start) state <= (start ? READ : IDLE);
                READ: if (done) state <= IDLE; else state <= READ; // stay in READ until done
                WRITE: if (done) state <= IDLE; else state <= WRITE; // stay in WRITE until done
            endcase
        end
    end
endmodule