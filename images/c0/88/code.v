module mfifo (
  i_wstrobe,
  i_dt,
  o_full,
  i_renable,
  o_dt,
  o_empty,
  o_dnum,
  clk,
  rst_x
);
parameter WIDTH = 32;
parameter RANGE = 2;
parameter DEPTH = 1 << RANGE;
input         i_wstrobe;      
input  [WIDTH-1:0] i_dt;      
output        o_full;         
input         i_renable;      
output [WIDTH-1:0] o_dt;      
output        o_empty;        
output [RANGE:0] o_dnum;      
input         clk;            
input         rst_x;          
reg [RANGE-1:0] rs_write_counter;
reg [RANGE-1:0] rs_read_counter;
reg [WIDTH-1:0] rs_data_buffer[0:DEPTH-1];
reg [RANGE:0] rs_status;
wire             o_full;
wire             o_empty;
wire [WIDTH-1:0] o_dt;
wire [1:0]       w_status;
wire             w_we;
wire             w_re;
assign o_full  = (rs_status == DEPTH);
assign o_empty = (rs_status == 0);
assign o_dt = rs_data_buffer[rs_read_counter];
assign o_dnum = rs_status;
assign w_we = !o_full & i_wstrobe;
assign w_re = i_renable & !o_empty;
assign w_status = {w_re,w_we};
  always @(posedge clk or negedge rst_x) begin
    if (~rst_x) begin
      rs_write_counter <= 'd0;
    end else begin
      if (w_we) begin
        rs_write_counter <= rs_write_counter + 1'b1;
      end
    end
  end
  always @(posedge clk) begin
    if (w_we) begin
      rs_data_buffer[rs_write_counter] <= i_dt;
    end
  end
  always @(posedge clk or negedge rst_x) begin
    if (~rst_x) begin
      rs_read_counter <= 'd0;
    end else begin
      if (w_re) begin
        rs_read_counter <= rs_read_counter + 1'b1;
      end
    end
  end
  always @(posedge clk or negedge rst_x) begin
    if (~rst_x) begin
      rs_status <= 'd0;
    end else begin
      case (w_status)
        2'b01:  rs_status <= rs_status + 1'b1; 
        2'b10:  rs_status <= rs_status - 1'b1; 
      endcase
    end
  end
endmodule