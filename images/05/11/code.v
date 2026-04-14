module fixed_priority_arbiter (
    input wire clk,
    input wire rst,
    input wire [3:0] request, // Request signals from R0 to R3
    output reg [3:0] grant     // Grant signal to R0 to R3
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            grant <= 4'b0000; // No grants on reset
        end else begin
            grant <= 4'b0000; // Clear grants
            if (request[0]) grant <= 4'b0001; // R0 has highest priority
            else if (request[1]) grant <= 4'b0010; // R1
            else if (request[2]) grant <= 4'b0100; // R2
            else if (request[3]) grant <= 4'b1000; // R3
        end
    end
endmodule