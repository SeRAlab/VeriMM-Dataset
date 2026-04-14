module NVMe_Controller_Status (
    input clk,
    input reset,
    input command_received,
    input command_done,
    input error_detected,
    output reg [2:0] status // status: {Error, Busy, Ready}
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            status <= 3'b000; // Reset all status
        end else begin
            if (error_detected) begin
                status <= 3'b100; // Set Error, clear Busy and Ready
            end else if (command_received) begin
                status <= 3'b010; // Set Busy, clear Ready and Error
            end else if (command_done) begin
                status <= 3'b001; // Set Ready, clear Busy and Error
            end
        end
    end

endmodule