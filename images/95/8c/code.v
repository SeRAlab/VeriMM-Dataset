module top_module(
    input [1:0] binary,
    output reg [5:0] grey
    );always @ (binary)
    begin
    grey = 6'd0;
    case (binary) 
    0: grey = 6'd1;
    1: grey = 6'd3;
    2: grey = 6'd2;
    endcase
    end
    
endmodule