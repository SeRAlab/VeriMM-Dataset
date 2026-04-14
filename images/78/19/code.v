module top_module(clock, reset, d, q, load);input clock, reset, load;
    input [15:0] d;
    output reg [15:0] q;
    
    
    always @ (posedge reset or posedge clock) begin
        if(reset) q <= 16'b0;
        else
            if(load) q <= d;
    end 
endmodule