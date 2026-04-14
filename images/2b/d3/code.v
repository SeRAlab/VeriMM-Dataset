module round_robin_arbiter(
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [3:0] request, // 4 request lines
    output reg [3:0] grant // 4 grant lines
);
    reg [1:0] current_grant; // 2-bit pointer to track current grant position

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_grant <= 2'b00;
            grant <= 4'b0000;
        end else if (enable) begin
            // Grant access based on round robin scheduling
            if (request) begin
                grant <= 4'b0000; // Reset grant
                grant[current_grant] <= 1'b1; // Grant current position

                // Move to the next grant position
                current_grant <= (current_grant + 1) % 4; // Wrap around at 4
            end else begin
                grant <= 4'b0000; // No grant if no request
            end
        end
    end
endmodule