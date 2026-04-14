module top_module();reg a = 0;


reg b, c, d = 0;


reg signed [7:0] data = 8'shF0;



function signed [7:0] adder;
  input a_in;
  input b_in;
  input c_in;
  input signed [7:0] data_in;
  begin
    adder = a_in + b_in + c_in + data_in;
  end
endfunction

endmodule