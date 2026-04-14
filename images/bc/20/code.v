module top_module( 
    input [254:0] in,
    output [7:0] out );reg [7:0] index;
    integer i;
    
    always @(*) begin
        index = 8'b00000000;
        for(i = 254; i >= 0; i = i - 1) begin
            if(in[i] == 1'b1) begin
                index = i;
            end
        end
    end
    
    assign out = index;
    
endmodule