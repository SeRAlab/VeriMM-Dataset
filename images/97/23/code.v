module top_module(
                rddata,                 // Output

                wrdata,                 // Inputs
                wr_ptr,
                rd_ptr,
                we,
                rst,
                clk
                );output [49:0] rddata;

  input  [49:0] wrdata;
  input   [2:0] wr_ptr;
  input   [2:0] rd_ptr;

  input         we;
  input         rst;
  input         clk;
 

  //******************************************************************//
  // Construct the RAM.                                               //
  //******************************************************************//

  reg    [49:0] lutram_data [0:7];

  always @(posedge clk) begin
    if (we)
      lutram_data[wr_ptr] <= #1 wrdata;
  end


  //******************************************************************//
  // Register the outputs.                                            //
  //******************************************************************//


  reg    [49:0] reg_rdata;


  always @(posedge clk or posedge rst)
  begin
    if (rst)  reg_rdata <= #1 50'h0000_0000_0000;
    else      reg_rdata <= #1 lutram_data[rd_ptr];
  end

  assign rddata = reg_rdata;


  //******************************************************************//
  //                                                                  //
  //******************************************************************//

endmodule