module top_module(
  input              clk,         
  input              rst,         

  input              i_wr,         
  input       [15:0] i_addr,       
  input              i_din,        
  output reg  [7:0]  o_dout,       

  input       [7:0]  i_jp1_state,  
  input       [7:0]  i_jp2_state   
);localparam [15:0] JOYPAD1_MMR_ADDR = 16'h4016;
localparam [15:0] JOYPAD2_MMR_ADDR = 16'h4017;


reg   [15:0]          r_prev_addr;
wire                  w_new_addr;
reg                   r_wrote_1_flag;
reg   [8:0]           r_jp1_state;
reg   [8:0]           r_jp2_state;



assign  w_new_addr  = (r_prev_addr != i_addr);


always @ (posedge clk) begin
  if (rst) begin
    o_dout                  <=  0;
    r_prev_addr             <=  0;
    r_wrote_1_flag          <=  0;
    r_jp1_state             <=  0;
    r_jp2_state             <=  0;
  end
  else begin
    
    if (i_addr[15:1] == JOYPAD1_MMR_ADDR[15:1]) begin
      
      
      o_dout              <= { 7'h00, ((i_addr[0]) ? r_jp2_state[0] : r_jp1_state[0]) };
      if (w_new_addr) begin
        if (i_wr && !i_addr[0]) begin
          if (!r_wrote_1_flag) begin
            if (i_din == 1'b1) begin
              r_wrote_1_flag    <= 1;
            end
          end
          else begin
            if (i_din == 1'b0) begin
              r_wrote_1_flag    <=  0;
              r_jp1_state     <=  {i_jp1_state, 1'b0};
              r_jp2_state     <=  {i_jp2_state, 1'b0};
            end
          end
        end
        
        else if (!i_wr && !i_addr[0]) begin
          r_jp1_state         <=  {1'b1, r_jp1_state[8:1]};
        end
        else if (!i_wr && i_addr[0]) begin
          r_jp2_state         <=  {1'b1, r_jp2_state[8:1]};
        end
      end
    end
    r_prev_addr             <=  i_addr;
  end
end
endmodule