module top_module(
           CLK_IN,
           reset,
           enb,
           u,
           count_debounce,
           y
          );input   CLK_IN;
  input   reset;
  input   enb;
  input   u;
  input   [7:0] count_debounce;  
  output  y;


  reg  u_n1;
  reg [7:0] count;  
  reg  y_reg;
  reg  u_n1_next;
  reg [7:0] count_next;  
  reg  y_reg_next;
  reg [8:0] add_temp_1;  


  always @(posedge CLK_IN)
    begin : libDebounce_c2_Count_Up_Down_process
      if (reset == 1'b1) begin
        u_n1 <= 1'b0;
        count <= 8'd0;
        y_reg <= 1'b0;
      end
      else if (enb) begin
        u_n1 <= u_n1_next;
        count <= count_next;
        y_reg <= y_reg_next;
      end
    end

  always @(u, u_n1, count, count_debounce, y_reg) begin
    count_next = count;
    y_reg_next = y_reg;
    
    
    
    
    if (u == u_n1) begin
      
      
      if (count >= count_debounce) begin
        
        
        y_reg_next = u;
        
      end
      else begin
        
        add_temp_1 = count + 1;
        if (add_temp_1[8] != 1'b0) begin
          count_next = 8'b11111111;
        end
        else begin
          count_next = add_temp_1[7:0];
        end
      end
      
    end
    else begin
      
      count_next = 8'd0;
    end
    
    u_n1_next = u;
  end

  assign y = y_reg_next;



endmodule