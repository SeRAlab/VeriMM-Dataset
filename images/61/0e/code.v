module top_module(
    input d, enable, _reset,
    output q, _q);wire and0, and1;
    
    assign and0 = ~d & enable;
    assign and1 =  d & enable;
    
    assign  q = ~(and0 | _q | ~_reset);
    assign _q = ~(and1 |  q);endmodule