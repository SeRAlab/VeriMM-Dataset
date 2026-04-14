module nvme_command_register(
    input wire clk,
    input wire reset,
    input wire [2:0] command_in,
    output reg [2:0] state_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_out <= 3'b000;
        end else begin
            state_out <= command_in;
        end
    end
endmodule