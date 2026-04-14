module top_module(
    input       clk,
    input       rst,
    input [3:0] dly,
    input       din,
    output      dout
);reg [15:0] sr=0;
`ifdef SHREG_SEQUENTIAL_RESET
    always @ (posedge clk) begin
        sr <= {sr[14:0], din & ~rst}; 
    end
`else 

    always @ (posedge clk) begin
       if (rst) sr <=0;
       else     sr <= {sr[14:0],din}; 
    end
`endif
`ifdef SIMULATION
    assign dout = (|sr) ? ((&sr) ? 1\'b1 : sr[dly]) :  1\'b0 ;
`else
    assign dout =sr[dly];
`endif        
endmodule