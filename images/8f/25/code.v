module top_module(input_1,
input_2,
and_gate
);input input_1;
input input_2;
output and_gate;
reg setup;


always @ (input_1 or input_2)
  begin
    setup = input_1 & input_2;
  end


always @ (posedge input_1)
  begin
    setup <= input_2;
  end


reg test1 = 1'b1; 
reg test2 = 1'b0; 
reg test3 = 1'b0; 
reg test4 = 1'b0; 
 
always @ (posedge input_2)
  begin
    
    
    test2 <= test1;
    test3 <= test2;
    test4 <= test3;
  end

endmodule