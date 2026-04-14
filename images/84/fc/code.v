module top_module(input w, input clk, input rst, output z);reg [1:0] state, nextState;
    
    parameter [1:0] zero=2'b00, edg=2'b01, one=2'b10; 
    
    always @ (w or state)
        case (state)
            zero: if (w) nextState = edg;
             else nextState = zero;
            edg: if (w) nextState = one;
             else nextState = zero;
            one: if (w) nextState = one;
             else nextState = zero;
        endcase
    
    always @ (posedge clk or negedge rst) begin
        if(rst)
            state <= zero;
        else
            state <= nextState;
    end
    assign z = (state == edg); 
endmodule