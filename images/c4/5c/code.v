module mux4(enable, select, in0, in1, in2, in3, out);
    input enable;
    input [1:0] select;
    input in0, in1, in2, in3;
    output out;
    
    wire [3:0] mux_out;
    
    assign mux_out[0] = (enable) ? in0 : 1'b0;
    assign mux_out[1] = (enable) ? in1 : 1'b0;
    assign mux_out[2] = (enable) ? in2 : 1'b0;
    assign mux_out[3] = (enable) ? in3 : 1'b0;
    
    assign out = mux_out[select];
    
endmodule