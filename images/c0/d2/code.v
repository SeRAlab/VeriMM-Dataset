module fm_ififo (
  clk_core,
  rst_x,
  i_wstrobe,
  i_dt,
  o_full,
  i_renable,
  o_dt,
  o_empty
);
parameter WIDTH = 32;
input         i_wstrobe;      
input  [WIDTH-1:0] i_dt;      
output        o_full;         
input         i_renable;      
output [WIDTH-1:0] o_dt;      
output        o_empty;        
input         clk_core;        
input         rst_x;          
reg [2:0] rs_write_counter;
reg [2:0] rs_read_counter;
reg [WIDTH-1:0] rs_data_buffer[0:4];  
reg [2:0] rs_status;
wire             o_full;
wire             o_empty;
wire [WIDTH-1:0] o_dt;
wire [1:0]       w_status;
wire             w_we;
wire             w_re;
reg [2:0] w_next_write_counter;
reg [2:0] w_next_read_counter;
assign o_full  = (rs_status == 5);
assign o_empty = (rs_status == 0);
assign o_dt = rs_data_buffer[rs_read_counter];
assign w_we = !o_full & i_wstrobe;
assign w_re = i_renable & !o_empty;
assign w_status = {w_re,w_we};
always @(*) begin
  if (rs_write_counter == 3'd4) w_next_write_counter = 3'd0; 
  else w_next_write_counter = rs_write_counter +1'b1;
end
always @(*) begin
 if (rs_read_counter == 3'd4) w_next_read_counter = 3'd0; 
 else w_next_read_counter = rs_read_counter +1'b1;
end
  always @(posedge clk_core or negedge rst_x) begin
    if (~rst_x) begin
      rs_write_counter <= 'd0;
    end else begin
      if (w_we) begin
        rs_write_counter <= w_next_write_counter;
      end
    end
  end
  integer i;
  always @(posedge clk_core or negedge rst_x) begin
    if (~rst_x) begin
      for (i = 0; i < 5; i = i + 1) begin
        rs_data_buffer[i] <= 0;
      end
    end else begin
      if (w_we) begin
        rs_data_buffer[rs_write_counter] <= i_dt;
      end
    end
  end
  always @(posedge clk_core or negedge rst_x) begin
    if (~rst_x) begin
      rs_read_counter <= 'd0;
    end else begin
      if (w_re) begin
        rs_read_counter <= w_next_read_counter;
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