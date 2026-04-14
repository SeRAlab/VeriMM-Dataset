module top_module(
    input [3:0] in,
    output reg [1:0] pos  );always @(*)begin
        
        
        
        case (1)
            in[0]==1:pos = 0;
            in[1]==1:pos = 1;
            in[2]==1:pos = 2;
            in[3]==1:pos = 3;
            default :
                pos = 0;
        endcase
    end
    
endmodule