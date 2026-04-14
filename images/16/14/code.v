module nvme_controller (
    input wire clk,
    input wire rst,
    input wire [1:0] cmd_type,    // 00: read, 01: write
    input wire [31:0] addr,
    input wire [31:0] data_in,
    output reg [31:0] data_out,
    output reg status           // 1 for success, 0 for failure
);
    reg [31:0] memory [0:255]; // memory array of 256 words

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            status <= 0;
            data_out <= 32'b0;
        end else begin
            if (addr < 256) begin
                case (cmd_type)
                    2'b00: begin // Read command
                        data_out <= memory[addr];
                        status <= 1;  // Success
                    end
                    2'b01: begin // Write command
                        memory[addr] <= data_in;
                        status <= 1;  // Success
                    end
                    default: begin
                        status <= 0;  // Invalid command
                    end
                endcase
            end else begin
                status <= 0;  // Invalid address
            end
        end
    end
endmodule