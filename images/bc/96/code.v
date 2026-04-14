module top_module(
    input clk,
    input reset,       // Asynchronous reset
    input slowena,     // Enable input for decade counter
    output [15:0] q    // 16-bit output from 4-to-16 decoder
);// Decade counter
    reg [3:0] count;
    always @(posedge clk or negedge reset) begin
        if (reset == 0) begin
            count <= 0;
        end else if (slowena) begin
            count <= count + 1;
        end
    end
    
    // 4-to-16 decoder
    wire [15:0] decoder_out;
    assign decoder_out = (count == 10'h0) ? 16'h03FF :
                         (count == 10'h1) ? 16'h03FE :
                         (count == 10'h2) ? 16'h03FC :
                         (count == 10'h3) ? 16'h03F8 :
                         (count == 10'h4) ? 16'h03F0 :
                         (count == 10'h5) ? 16'h03E0 :
                         (count == 10'h6) ? 16'h03C0 :
                         (count == 10'h7) ? 16'h0380 :
                         (count == 10'h8) ? 16'h0300 :
                         (count == 10'h9) ? 16'h0200 :
                         (count == 10'ha) ? 16'h0100 :
                         (count == 10'hb) ? 16'h0080 :
                         (count == 10'hc) ? 16'h0040 :
                         (count == 10'hd) ? 16'h0020 :
                         (count == 10'he) ? 16'h0010 :
                                           16'h0008 ;
    assign q = decoder_out;

endmodule