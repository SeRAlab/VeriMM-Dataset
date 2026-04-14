module nvme_controller (
    input wire clk,
    input wire rst_n,
    input wire enable,
    input wire [1:0] command_type, // 00: No Operation, 01: Read, 10: Write
    input wire [15:0] start_address,
    input wire [31:0] write_data,
    output reg [31:0] read_data,
    output reg status // 0: Failure, 1: Success
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            status <= 0;
            read_data <= 32'b0;
        end else if (enable) begin
            case (command_type)
                2'b01: begin // Read
                    read_data <= 32'hDEADBEEF; // Placeholder data
                    status <= 1;
                end
                2'b10: begin // Write
                    // Simulate writing data
                    status <= 1;
                end
                default: begin // No Operation
                    status <= 0;
                end
            endcase
        end
    end
endmodule