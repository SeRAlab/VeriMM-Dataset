module top_module(
    input [3:0] in, // 4-bit input to the priority encoder
    input clk, // Clock input
    input reset, // Active-high synchronous reset input
    output reg [3:0] count // 4-bit output of the counter
);wire [1:0] enc1_out; // Output of the first 4-to-2 priority encoder
wire [3:0] enc2_out; // Output of the second 4-to-2 priority encoder

// Implementing the first 4-to-2 priority encoder using NAND gates
assign enc1_out[0] = ~(in[0] & in[1]);
assign enc1_out[1] = ~(in[2] & in[3]);

// Implementing the second 4-to-2 priority encoder using NAND gates
assign enc2_out[0] = ~(enc1_out[0] & enc1_out[1]);
assign enc2_out[1] = ~(enc1_out[0] & ~enc1_out[1]);
assign enc2_out[2] = ~(~enc1_out[0] & enc1_out[1]);
assign enc2_out[3] = ~(~enc1_out[0] & ~enc1_out[1]);

always @(posedge clk) begin
    if (reset) begin
        count <= 0;
    end else begin
        case (enc2_out)
            4'b0001: count <= count + 1;
            default: count <= 0;
        endcase
    end
end

endmodule