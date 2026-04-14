module nvme_controller (
    input wire clk,
    input wire rst,
    input wire [1:0] command, // 00: IDLE, 01: READ, 10: WRITE
    output reg [1:0] status // 00: IDLE, 01: READING, 10: WRITING
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            status <= 2'b00; // IDLE
        end else begin
            case (command)
                2'b01: status <= 2'b01; // READING
                2'b10: status <= 2'b10; // WRITING
                default: status <= 2'b00; // IDLE
            endcase
        end
    end
endmodule