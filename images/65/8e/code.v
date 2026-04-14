module top_module();if (1) begin: GenConstFunc
      
      
      function automatic bit constFunc();
         constFunc = 1'b1;
      endfunction

      localparam PARAM = constFunc();
    end
endmodule