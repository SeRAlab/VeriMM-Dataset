module top_module(
    reset,
    quadA, 
    quadB, 
    count
);input reset, quadA, quadB;
    output [7:0] count;

    reg [3:0] combined; 
    reg [7:0] total;
    reg [2:0] num;

    always @ ( * )
    begin
        if (reset) begin
            combined = 4'b0000;
            total = 0;
            num = 0;
        end
        else begin
            
            
            combined = combined << 2;
            combined = combined | {quadA, quadB};

            num = 0;
            case (combined)
                4'b0000 : num =  2'd0;
                4'b0001 : num = -2'd1;
                4'b0010 : num =  2'd1;
                4'b0011 : num =  2'd0;

                4'b0100 : num =  2'd1;
                4'b0101 : num =  2'd0;
                4'b0110 : num =  2'd0;
                4'b0111 : num = -2'd1;

                4'b1000 : num = -2'd1;
                4'b1001 : num =  2'd0;
                4'b1010 : num =  2'd0;
                4'b1011 : num =  2'd1;

                4'b1100 : num =  2'd0;
                4'b1101 : num =  2'd1;
                4'b1110 : num = -2'd1;
                4'b1111 : num =  2'd0;
            endcase
            
            
            total = $signed(total) + $signed(num);
            
            
        end
    end
    
    assign count = total;
endmodule