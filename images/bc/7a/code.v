module top_module(
    RS_VALUE,
    MEM_WB_VALUE,
    EX_MEM_VALUE,
    forward_control,
    VALUE_OUT
);input   [31:0]      RS_VALUE;
input   [31:0]      MEM_WB_VALUE;
input   [31:0]      EX_MEM_VALUE;
input   [1:0]       forward_control;
output  [31:0]      VALUE_OUT;

assign  VALUE_OUT=  (forward_control==2'b00)?RS_VALUE:
                    (forward_control==2'b10)?EX_MEM_VALUE:
                    (forward_control==2'b01)?MEM_WB_VALUE:
                    32'bx;
                    

endmodule