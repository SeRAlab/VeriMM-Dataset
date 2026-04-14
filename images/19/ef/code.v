module sata_controller (
    input wire clk,
    input wire reset,
    input wire start,
    input wire done,
    input wire finish,
    output reg [1:0] state
);
    parameter IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: if (start) state <= READ;
                READ: if (done) state <= WRITE;
                WRITE: if (finish) state <= IDLE;
            endcase
        end
    end
endmodule