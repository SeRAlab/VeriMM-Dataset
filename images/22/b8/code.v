module nvme_command_register (
    input wire clk,
    input wire reset,
    input wire valid,
    input wire [31:0] command_in,
    output reg [31:0] command_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            command_out <= 32'b0;
        end else if (valid) begin
            command_out <= command_in;
        end
    end
endmodule