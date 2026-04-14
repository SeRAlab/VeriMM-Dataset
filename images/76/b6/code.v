module top_module();reg [2:0] test = 0;

  function integer my_func;
    input incr;
    begin
      test = test + incr;
      my_func = test;
    end
  endfunction
endmodule