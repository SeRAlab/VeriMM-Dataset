module fixed_priority_arbiter (
    input wire clk,
    input wire reset,
    input wire [3:0] request, // 4 request lines
    output reg [3:0] grant     // 4 grant lines
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        grant <= 4'b0000; // No grants on reset
    end else begin
        case (request)
            4'b0001: grant <= 4'b0001; // Grant to Requestor 0
            4'b0010: grant <= 4'b0010; // Grant to Requestor 1
            4'b0100: grant <= 4'b0100; // Grant to Requestor 2
            4'b1000: grant <= 4'b1000; // Grant to Requestor 3
            4'b0011: grant <= 4'b0001; // Grant to Requestor 0
            4'b0110: grant <= 4'b0010; // Grant to Requestor 1
            4'b1111: grant <= 4'b0001; // Grant to Requestor 0
            default: grant <= 4'b0000;  // No grants if no valid request
        endcase
    end
end

endmodule