module top_module(
    in1, in2, op, out
);input wire [31:0] in1, in2;
    input wire [5:0] op;
    output reg [31:0] out;

    always @(*) begin
        case(op)
				1: out <= in1+in2;							
				2: out <= in1-in2;							
				3: out <= in1&in2;							
				4: out <= in1|in2;							
				5: out <= in1^in2;							
				6: out <= in1<<in2[4:0];					
				7: out <= in1>>in2[4:0];					
				8: out <= $signed(in1)>>>in2[4:0];			
				9: out <= ($signed(in1)<$signed(in2))? 1:0;	
				10: out <= (in1<in2)? 1:0;					
				11: out <= (in1==in2) ? 1:0; 					
				12: out <= (in1!=in2) ? 1:0; 					
				13: out <= ($signed(in1)>=$signed(in2))? 1:0;	
				14: out <= (in1>=in2)? 1:0;					
				15: out <= in2;
				default: out <= 0;
		  endcase
    end

endmodule