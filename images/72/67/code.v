module top_module(aclk);output aclk;
    reg aclk;

    task clockit;
      begin
        #100 aclk = 1;
        #100 aclk = 0;
      end
    endtask
  endmodule