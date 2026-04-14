module nvme_controller_csr (
    input wire clk,
    input wire reset,
    input wire [1:0] command_status, // 00: IDLE, 01: RUNNING, 10: COMPLETED
    output reg [1:0] current_status // 00: IDLE, 01: RUNNING, 10: COMPLETED
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_status <= 2'b00; // IDLE
        end else begin
            current_status <= command_status;
        end
    end
endmodule