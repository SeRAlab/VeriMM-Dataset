module nvme_command_register(
    input wire clk,
    input wire reset,
    input wire write_enable,
    input wire [7:0] command_in,
    output reg [7:0] command_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            command_out <= 8'b0; // Clear the register on reset
        end else if (write_enable) begin
            command_out <= command_in; // Write command to register
        end
    end
endmodule