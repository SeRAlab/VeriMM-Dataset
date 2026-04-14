module top_module(input clk,
                  input             reset,

                  input [31:0]      ic_addr,
                  input             ic_rq,
                  output reg        ic_data_out_valid,
                  output reg [31:0] ic_data_out,

                  // memory bus interface
                  input [31:0]      data_in, // bus data in
                  input             data_in_ready, // bus data ready
                  output reg        data_rd, // request data read 
                  output reg [31:0] data_address // output data address
                  );always @(posedge clk)
     begin
        if (reset) begin
            data_address <= 0;
            data_rd <= 0;
            ic_data_out_valid <= 0;
            ic_data_out <= 0;
        end
        else begin
            data_address <= ic_addr;
            data_rd <= ic_rq;
            if (data_in_ready) begin
                ic_data_out <= data_in;
                ic_data_out_valid <= 1;
            end
            else begin
                ic_data_out_valid <= 0;
            end
        end
     end

endmodule