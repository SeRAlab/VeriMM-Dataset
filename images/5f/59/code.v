module shift_register_4bit (out, clk, reset, serial_in);
   input clk, reset, serial_in;
   output [3:0] out;
   
   reg [3:0] out;

always @(posedge clk) begin
    if (reset) 
        out <= 4'b0000;
    else 
        out <= {out[2:0], serial_in};
end

endmodule