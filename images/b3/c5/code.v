module priority_encoder_4bit (q, v, d);
   input [3:0] d;
   output [1:0] q;
   output v;
   
   reg [1:0] q;
   reg v;

always @(d) begin
    casez (d)
        4'b1???: begin q = 2'b11; v = 1; end
        4'b01??: begin q = 2'b10; v = 1; end
        4'b001?: begin q = 2'b01; v = 1; end
        4'b0001: begin q = 2'b00; v = 1; end
        default: begin q = 2'b00; v = 0; end
    endcase
end

endmodule