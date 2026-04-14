module fm_fifo (
  clk_core,
  rst_x,
  i_wstrobe,
  i_dt,
  o_full,
  i_renable,
  o_dt,
  o_empty,
  o_dnum
);
parameter P_WIDTH = 32;
parameter P_RANGE = 2;
parameter P_DEPTH = 1 << P_RANGE;
parameter P_CLEAR = "FALSE";
input         clk_core;            
input         rst_x;          
input         i_wstrobe;      
input  [P_WIDTH-1:0] i_dt;      
output        o_full;         
input         i_renable;      
output [P_WIDTH-1:0] o_dt;      
output        o_empty;        
output [P_RANGE:0] o_dnum;      
reg [P_RANGE-1:0] rs_write_counter;
reg [P_RANGE-1:0] rs_read_counter;
reg [P_WIDTH-1:0] rs_data_buffer[0:P_DEPTH-1];
reg [P_RANGE:0] rs_status;
wire             o_full;
wire             o_empty;
wire [P_WIDTH-1:0] o_dt;
wire [1:0]       w_status;
wire             w_we;
wire             w_re;
assign o_full  = (rs_status == P_DEPTH);
assign o_empty = (rs_status == 0);
assign o_dt = rs_data_buffer[rs_read_counter];
assign o_dnum = rs_status;
assign w_we = !o_full & i_wstrobe;
assign w_re = i_renable & !o_empty;
assign w_status = {w_re,w_we};
  always @(posedge clk_core or negedge rst_x) begin
    if (~rst_x) begin
      rs_write_counter <= 'd0;
    end else begin
      if (w_we) begin
        rs_write_counter <= rs_write_counter + 1'b1;
      end
    end
  end
generate
  if (P_CLEAR == "TRUE") begin
    integer i;
    always @(posedge clk_core or negedge rst_x) begin
      if (~rst_x) begin
        for(i=0;i<P_DEPTH;i=i+1) rs_data_buffer[i] <= 'd0;
      end else begin
        if (w_we) begin
          rs_data_buffer[rs_write_counter] <= i_dt;
        end
      end
    end
  end else begin
    always @(posedge clk_core) begin
      if (w_we) begin
        rs_data_buffer[rs_write_counter] <= i_dt;
      end
    end
  end
endgenerate   
  always @(posedge clk_core or negedge rst_x) begin
    if (~rst_x) begin
      rs_read_counter <= 'd0;
    end else begin
      if (w_re) begin
        rs_read_counter <= rs_read_counter + 1'b1;
      end
    end
  end
  always @(posedge clk_core or negedge rst_x) begin
    if (~rst_x) begin
      rs_status <= 'd0;
    end else begin
      case (w_status)
        2'b01:  rs_status <= rs_status + 1'b1; 
        2'b10:  rs_status <= rs_status - 1'b1; 
        default:  rs_status <= rs_status;      
      endcase
    end
  end
endmodule