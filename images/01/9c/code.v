module fixed_priority_arbiter (
    input wire clk,
    input wire reset,
    input wire [3:0] request, // Request signals from R0, R1, R2, R3
    output reg [3:0] grant     // Grant signal for the selected requestor
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        grant <= 4'b0000; // No grant on reset
    end else begin
        case (1'b1) // Check for highest priority request
            request[0]: grant <= 4'b0001; // R0 has highest priority
            request[1]: grant <= 4'b0010; // R1
            request[2]: grant <= 4'b0100; // R2
            request[3]: grant <= 4'b1000; // R3
            default: grant <= 4'b0000; // No grant
        endcase
    end
end

endmodule