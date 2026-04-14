module nvme_controller (
    input wire clk,
    input wire rst,
    input wire [1:0] command_type, // 2-bit command type (00: NOP, 01: READ, 10: WRITE, 11: FLUSH)
    output reg [1:0] status // 2-bit status output (00: IDLE, 01: IN_PROGRESS, 10: DONE, 11: ERROR)
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            status <= 2'b00; // IDLE state
        end else begin
            case (command_type)
                2'b00: status <= 2'b00; // NOP
                2'b01: begin
                    status <= 2'b01; // IN_PROGRESS for READ
                    // Simulate READ operation
                    #5; // Simulating some read delay
                    status <= 2'b10; // DONE
                end
                2'b10: begin
                    status <= 2'b01; // IN_PROGRESS for WRITE
                    // Simulate WRITE operation
                    #5; // Simulating some write delay
                    status <= 2'b10; // DONE
                end
                2'b11: begin
                    status <= 2'b11; // ERROR for FLUSH
                end
                default: status <= 2'b11; // ERROR
            endcase
        end
    end
endmodule