module round_robin_arbiter(
    input wire clk,
    input wire rst,
    input wire enable,
    input wire [3:0] request,
    output reg [3:0] grant
);
    reg [1:0] current_priority;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 4'b0000;
            current_priority <= 2'b00;
        end else if (enable) begin
            grant <= 4'b0000; // Reset grants
            if (request) begin
                // Grant access based on current priority
                case(current_priority)
                    2'b00: if (request[0]) grant[0] <= 1'b1; else if (request[1]) grant[1] <= 1'b1;
                    2'b01: if (request[1]) grant[1] <= 1'b1; else if (request[2]) grant[2] <= 1'b1;
                    2'b10: if (request[2]) grant[2] <= 1'b1; else if (request[3]) grant[3] <= 1'b1;
                    2'b11: if (request[3]) grant[3] <= 1'b1; else if (request[0]) grant[0] <= 1'b1;
                endcase
                
                // Update priority for next round
                if (grant == 4'b0000) begin
                    current_priority <= (current_priority + 1) % 4;
                end
            end
        end
    end
endmodule