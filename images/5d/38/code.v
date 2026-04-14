module top_module(
    input clk,
    input reset,       // Synchronous active-high reset
    input [7:0] in,    // 8-bit input for the priority encoder
    output reg [2:0] pe_out,  // 3-bit output from the priority encoder
    output reg q       // Output from the D flip-flop delayed by one clock cycle
);// Priority Encoder
always @(*) begin
    if (in[7]) pe_out = 3'd7;
    else if (in[6]) pe_out = 3'd6;
    else if (in[5]) pe_out = 3'd5;
    else if (in[4]) pe_out = 3'd4;
    else if (in[3]) pe_out = 3'd3;
    else if (in[2]) pe_out = 3'd2;
    else if (in[1]) pe_out = 3'd1;
    else if (in[0]) pe_out = 3'd0;
    else pe_out = 3'd0; // Default case when all inputs are low
end

// D Flip-Flop
always @(posedge clk) begin
    if (reset) begin
        q <= 1'b0;
    end
    else begin
        q <= pe_out[0]; // Store the LSB of pe_out in q
    end
end

endmodule