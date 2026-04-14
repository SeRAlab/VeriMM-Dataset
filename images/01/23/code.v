module round_robin_arbiter (
    input wire clk,
    input wire reset,
    input wire [2:0] req,
    output reg [2:0] grant
);
    reg [1:0] last_granted; // To keep track of the last granted request

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 3'b000; // Reset grant
            last_granted <= 2'b00;
        end else begin
            // Round-robin logic
            if (|req) begin
                last_granted <= (last_granted + 1) % 3; // Next request
                grant <= 3'b000; // Reset grants
                if (req[last_granted]) begin
                    grant[last_granted] <= 1'b1; // Grant the current request
                end else if (req[(last_granted + 1) % 3]) begin
                    grant[(last_granted + 1) % 3] <= 1'b1; // Grant next if available
                end else if (req[(last_granted + 2) % 3]) begin
                    grant[(last_granted + 2) % 3] <= 1'b1; // Grant next if available
                end
            end else begin
                grant <= 3'b000; // No requests
            end
        end
    end
endmodule