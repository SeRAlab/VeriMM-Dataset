module top_module( input wire clk, input wire rst,input wire [3:0] BTN,input wire [7:0]SW,input wire mem_w,input wire [31:0] Cpu_data2bus,input wire [31:0] addr_bus,input wire [31:0] ram_data_out,input wire [7:0] led_out,input wire [31:0] counter_out,input wire counter0_out,input wire counter1_out,input wire counter2_out,output reg [31:0] Cpu_data4bus,output reg [31:0] ram_data_in,output reg [9: 0] ram_addr,output reg data_ram_we,output reg GPIOf0000000_we,output reg GPIOe0000000_we,output reg counter_we,output reg [31: 0] Peripheral_in);reg [7:0] led_in; 
  always @(*) begin 
  data_ram_we = 0; 
  counter_we = 0; 
  GPIOe0000000_we = 0; 
  GPIOf0000000_we = 0; 
  ram_addr = 10'h0; 
  ram_data_in = 32'h0; 
  Peripheral_in = 32'h0; 
  Cpu_data4bus = 32'h0; 
  case(addr_bus[31:28]) 
  4'h0: begin 
  data_ram_we = mem_w ; 
  ram_addr = addr_bus[11:2]; 
  ram_data_in = Cpu_data2bus; 
  Cpu_data4bus = ram_data_out; 
  end 
  4'he: begin 
  GPIOf0000000_we = mem_w; 
  Peripheral_in = Cpu_data2bus; 
  Cpu_data4bus = counter_out; 
  end 
  4'hf: begin 
  if(addr_bus[2]) begin 
  counter_we = mem_w; 
  Peripheral_in = Cpu_data2bus; 
  Cpu_data4bus = counter_out; 
  end else begin 
  GPIOf0000000_we = mem_w; 
  Peripheral_in = Cpu_data2bus; 
  Cpu_data4bus = {counter0_out, counter1_out, counter2_out, 9'h00, led_out, BTN, SW}; 
  end 
  end 
  endcase 
  end 
 endmodule