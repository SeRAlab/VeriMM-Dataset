module shift_register_4bit(
    input clk,
    input reset,
    input in,
    output reg [3:0] out);
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            out <= 4'b0000;
        else
            out <= {out[2:0], in};
    end
endmodule