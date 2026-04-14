module pcie_endpoint_controller (
    input clk,
    input reset,
    input start_read,
    input start_write,
    output reg [1:0] current_state, // 00: IDLE, 01: READ, 10: WRITE
    output reg read_active,
    output reg write_active
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam READ = 2'b01;
    localparam WRITE = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            read_active <= 0;
            write_active <= 0;
        end else begin
            case (current_state)
                IDLE: begin
                    if (start_read) begin
                        current_state <= READ;
                        read_active <= 1;
                    end else if (start_write) begin
                        current_state <= WRITE;
                        write_active <= 1;
                    end
                end
                READ: begin
                    if (read_active) begin
                        // Complete read operation
                        current_state <= IDLE;
                        read_active <= 0;
                    end
                end
                WRITE: begin
                    if (write_active) begin
                        // Complete write operation
                        current_state <= IDLE;
                        write_active <= 0;
                    end
                end
            endcase
        end
    end
endmodule