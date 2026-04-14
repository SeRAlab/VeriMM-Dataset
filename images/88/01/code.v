module top_module(
  
  clk,           
  rst,           
  DCR_ABus,      
  DCR_DBusIn,    
  DCR_Read,      
  DCR_Write,     
  DCR_Ack,       
  DCR_DBusOut,   
  
  tft_base_addr, 
  tft_dps_reg,   
  tft_on_reg     
  );input         clk;
  input         rst;
  input  [0:9]  DCR_ABus;
  input  [0:31] DCR_DBusIn;
  input         DCR_Read;
  input         DCR_Write;
  output        DCR_Ack;
  output [0:31] DCR_DBusOut;
  output [0:10] tft_base_addr;
  output        tft_dps_reg;
  output        tft_on_reg;
  wire   [0:31] DCR_DBusOut;
  reg           DCR_Ack;





  parameter C_DCR_BASE_ADDR = 10'b00_0000_0000;
  parameter C_DEFAULT_TFT_BASE_ADDR = 11'b000_0000_0000;
  parameter C_DPS_INIT = 1'b1;
  parameter C_ON_INIT = 1'b1;





  wire        dcr_addr_hit;
  wire [0:9]  dcr_base_addr;
  reg         dcr_read_access;
  reg  [0:31] read_data;
  reg  [0:10] tft_base_addr;
  reg         tft_dps_reg;
  reg         tft_on_reg;





  assign dcr_base_addr = C_DCR_BASE_ADDR;
  assign dcr_addr_hit  = (DCR_ABus[0:8] == dcr_base_addr[0:8]);

  always @(posedge clk)
  begin
    dcr_read_access <=  DCR_Read              & dcr_addr_hit;
    DCR_Ack         <= (DCR_Read | DCR_Write) & dcr_addr_hit;
  end

  always @(posedge clk)
    if (rst)
      tft_base_addr <= C_DEFAULT_TFT_BASE_ADDR; 
    else if (DCR_Write & ~DCR_Ack & dcr_addr_hit & (DCR_ABus[9] == 1'b0))
      tft_base_addr <= DCR_DBusIn[0:10];

  always @(posedge clk)
    if (rst) begin
      tft_dps_reg <= C_DPS_INIT;
      tft_on_reg  <= C_ON_INIT;
    end
    else if (DCR_Write & ~DCR_Ack & dcr_addr_hit & (DCR_ABus[9] == 1'b1)) begin
      tft_dps_reg <= DCR_DBusIn[30];
      tft_on_reg  <= DCR_DBusIn[31];
    end

  always @(posedge clk)
    if (DCR_Read & dcr_addr_hit & ~DCR_Ack)
      read_data <= (DCR_ABus[9] == 1'b0)? {tft_base_addr, 21'b0} :
                                          {30'b0, tft_dps_reg, tft_on_reg};

  assign DCR_DBusOut = (dcr_read_access)? read_data : DCR_DBusIn;

endmodule