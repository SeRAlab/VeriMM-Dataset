module pcie_endpoint_controller (
    input clk,
    input reset,
    input start_read,
    input start_write,
    input complete,
    output reg [1:0] state
);
    // State encoding
    parameter IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start_read) begin
                        state <= READ;
                    end else if (start_write) begin
                        state <= WRITE;
                    end
                end
                READ: begin
                    if (complete) begin
                        state <= IDLE;
                    end
                end
                WRITE: begin
                    if (complete) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule