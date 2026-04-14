module pcie_endpoint_controller (
    input wire clk,
    input wire rst_n,
    input wire [1:0] operation, // 00: read, 01: write, 10: no operation
    input wire [31:0] address,
    input wire [31:0] write_data,
    output reg [31:0] read_data,
    output reg status // 0: failure, 1: success
);

    reg [31:0] memory [0:255]; // Simple memory array for demonstration

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            status <= 0;
            read_data <= 0;
        end else begin
            case (operation)
                2'b00: begin // Read operation
                    if (address < 256) begin
                        read_data <= memory[address];
                        status <= 1; // Success
                    end else begin
                        status <= 0; // Failure
                    end
                end
                2'b01: begin // Write operation
                    if (address < 256) begin
                        memory[address] <= write_data;
                        status <= 1; // Success
                    end else begin
                        status <= 0; // Failure
                    end
                end
                default: begin // No operation
                    status <= 1; // Success
                end
            endcase
        end
    end

endmodule