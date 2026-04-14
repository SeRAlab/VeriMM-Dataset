module pcie_endpoint_controller (
    input clk,
    input [1:0] command_type, // 00: Read, 01: Write, 10: Invalidate
    input [31:0] data_in,
    output reg [31:0] data_out,
    output reg valid_output
);

    always @(posedge clk) begin
        case (command_type)
            2'b00: begin // Read command
                data_out <= data_in; // Just echoing back for read
                valid_output <= 1;
            end
            2'b01: begin // Write command
                data_out <= data_in + 1; // Increment for write response
                valid_output <= 1;
            end
            2'b10: begin // Invalidate command
                data_out <= 32'b0; // Reset output for invalidate
                valid_output <= 1;
            end
            default: begin
                data_out <= 32'b0; // Default case
                valid_output <= 0;
            end
        endcase
    end
endmodule