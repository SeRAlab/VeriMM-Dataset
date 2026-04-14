module top_module(in, out);input [15:0] in;
    
    
    output reg [31:0] out;   
    
    
    
    always @ (in) begin
        if (in[15] == 0) begin
            out = 32'h0;
            out[15:0] = in;
        end
        else begin
            out[31:16] = 16'b1111111111111111;
            out[15:0] = in;
        end
    end
	

endmodule