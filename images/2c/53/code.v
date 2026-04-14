module nvme_command_controller (
    input wire clk,
    input wire reset,
    input wire [3:0] command_in,
    input wire submit_command,
    output reg [3:0] command_status
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        command_status <= 4'b0000; // Reset command status
    end else if (submit_command) begin
        command_status <= command_in; // Update command status
    end
end

endmodule