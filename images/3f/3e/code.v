module nvme_command_register (
    input wire clk,
    input wire [3:0] command_in,
    output reg [3:0] command_out
);

always @(posedge clk) begin
    command_out <= command_in;
end

endmodule