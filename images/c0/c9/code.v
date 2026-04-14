module fm_raw_fifo (
  clk_core,
  rst_x,
  i_check_address,
  o_hit,
  i_wstrobe,
  i_dt,
  o_full,
  i_renable,
  o_dt,
  o_empty,
  o_dnum
);
parameter WIDTH = 32;
parameter RANGEE = 4;
localparam DEPTH = 1 << RANGEE;
input         clk_core;            
input         rst_x;          
input  [WIDTH-1:0] i_check_address;
output        o_hit;
input         i_wstrobe;      
input  [WIDTH-1:0] i_dt;      
output        o_full;         
input         i_renable;      
output [WIDTH-1:0] o_dt;      
output        o_empty;        
output [RANGEE:0] o_dnum;      
reg [RANGEE-1:0] rs_write_counter;
reg [RANGEE-1:0] rs_read_counter;
reg [WIDTH-1:0] rs_data_buffer[0:DEPTH-1];
reg [DEPTH-1:0] rs_valid;
wire             o_full;
wire             o_empty;
wire [WIDTH-1:0] o_dt;
wire [1:0]       w_status;
wire             w_we;
wire             w_re;
wire [DEPTH-1:0] w_hit;
assign o_full  = (&rs_valid);
assign o_empty = ~(|rs_valid);
assign o_dt = rs_data_buffer[rs_read_counter];
assign o_dnum = 'd0;
assign w_we = !o_full & i_wstrobe;
assign w_re = i_renable & !o_empty;
assign w_status = {w_re,w_we};
assign o_hit = |w_hit;
  genvar i;
  generate for (i=0;i<DEPTH;i=i+1) begin : gen_loop
    assign w_hit[i] = rs_valid[i] ? (i_check_address == rs_data_buffer[i]) : 1'b0;
  end
  endgenerate
  always @(posedge clk_core or negedge rst_x) begin
    if (~rst_x) begin
      rs_write_counter <= 'd0;
    end else begin
      if (w_we) begin
        rs_write_counter <= rs_write_counter + 1'b1;
      end
    end
  end
  always @(posedge clk_core) begin
    if (w_we) begin
      rs_data_buffer[rs_write_counter] <= i_dt;
    end
  end
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
      rs_valid <= {DEPTH{1'b0}};
    end else begin
      case (w_status)
        2'b01: rs_valid[rs_write_counter] <= 1'b1; 
        2'b10: rs_valid[rs_read_counter]  <= 1'b0; 
        2'b11: begin
          rs_valid[rs_write_counter] <= 1'b1; 
          rs_valid[rs_read_counter]  <= 1'b0; 
        end
        default:  rs_valid <= rs_valid;      
      endcase
    end
  end
endmodule