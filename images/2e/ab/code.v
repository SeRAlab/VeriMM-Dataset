module nvme_controller_status (
    input wire clk,
    input wire rst_n,
    input wire cmd_submitted,
    input wire cmd_completed,
    input wire cmd_error,
    output reg [1:0] status // 00: idle, 01: in progress, 10: completed, 11: error
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            status <= 2'b00; // idle
        end else begin
            case (status)
                2'b00: begin // idle
                    if (cmd_submitted) 
                        status <= 2'b01; // in progress
                end
                2'b01: begin // in progress
                    if (cmd_completed) 
                        status <= 2'b10; // completed
                    else if (cmd_error) 
                        status <= 2'b11; // error
                end
                2'b10: begin // completed
                    status <= 2'b00; // back to idle
                end
                2'b11: begin // error
                    status <= 2'b00; // back to idle
                end
                default: status <= 2'b00; // safety
            endcase
        end
    end
endmodule