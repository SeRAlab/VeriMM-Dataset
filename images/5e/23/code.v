module top_module(
  input  wire        clock,
  input  wire        reset,
  input  wire        int_ack,  
  output reg         int_req,
  input  wire [15:0] A,
  input  wire  [7:0] Di,
  output wire  [7:0] Do,
  input  wire        rd_n,
  input  wire        wr_n,
  input  wire        cs,
  output reg   [1:0] button_sel,
  input  wire  [3:0] button_data
);always @(posedge clock) begin
    if (reset)
      int_req <= 0;
    else begin
      if (!wr_n) begin
        if (A == 16'hFF00)
          button_sel <= Di[5:4];
      end
    end
  end

  assign Do = (cs) ? { 2'b11, button_sel[1:0], button_data[3:0] } : 8'hFF;

endmodule