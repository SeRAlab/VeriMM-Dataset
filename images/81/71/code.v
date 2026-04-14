module top_module(input clk,
                  input             reset,

                  input [31:0]      ic_addr,
                  input             ic_rq,
                  output reg        ic_data_out_valid,
                  output reg [31:0] ic_data_out,

                  
                  input [31:0]      data_in, 
                  input             data_in_ready, 
                  output reg        data_rd, 
                  output reg [31:0] data_address 
                  );always @(posedge clk)
     begin
        data_address <= ic_addr;
        data_rd <= ic_rq;
        ic_data_out <= data_in;
        ic_data_out_valid <= data_in_ready;
     end

endmodule