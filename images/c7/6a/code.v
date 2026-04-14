module shift_register ( input clk, input d, output [2:0] q );
    wire [2:0] q_temp;
    
    assign q_temp[0] = d;
    assign q_temp[1] = q[0];
    assign q_temp[2] = q[1];
    
    assign q = q_temp;
endmodule