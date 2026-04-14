module top_module(
    input [3:0] hex, 
    output reg [3:0] bcd, 
	output reg carry 
    );always @* begin
        if (hex>4'b1001) begin  
            carry=1; 
            bcd[3:0]=hex-10;
            end 
        else begin
            bcd=hex;
			carry=0;
		end
    end
endmodule