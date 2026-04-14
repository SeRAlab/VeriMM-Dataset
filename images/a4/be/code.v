module top_module(
   input         RST_N,
   input         CLK,

   input         LOCAL_CS,
   input         LOCAL_RNW,
   output        LOCAL_ACK,
   input [31:0]  LOCAL_ADDR,
   input [3:0]   LOCAL_BE,
   input [31:0]  LOCAL_WDATA,
   output [31:0] LOCAL_RDATA,

   input [31:0]  GPIO_I,
   output [31:0] GPIO_OT
);localparam A_OUT   = 8'h00;
   localparam A_IN    = 8'h04;

   wire          wr_ena, rd_ena, wr_ack;
   reg           rd_ack;

   reg [31:0]    reg_gpio_o;
   reg [31:0]    reg_rdata;

   assign wr_ena = (LOCAL_CS & ~LOCAL_RNW)?1'b1:1'b0;
   assign rd_ena = (LOCAL_CS &  LOCAL_RNW)?1'b1:1'b0;
   assign wr_ack = wr_ena;

   
   always @(posedge CLK) begin
      if(!RST_N) begin
         reg_gpio_o <= 32'd0;
      end else begin
         if(wr_ena) begin
            case(LOCAL_ADDR[7:0] & 8'hFC)
              A_OUT: begin
                 reg_gpio_o <= LOCAL_WDATA;
              end
              default: begin
              end
            endcase
         end
      end
   end

   
   always @(posedge CLK) begin
      if(!RST_N) begin
         reg_rdata[31:0] <= 32'd0;
         rd_ack <= 1'b0;
      end else begin
         rd_ack <= rd_ena;
         if(rd_ena) begin
            case(LOCAL_ADDR[7:0] & 8'hFC)
              A_OUT: begin
               reg_rdata[31:0] <= reg_gpio_o[31:0];
              end
              A_IN: begin
                 reg_rdata[31:0] <= GPIO_I;
              end
              default: begin
                 reg_rdata[31:0] <= 32'd0;
              end
            endcase
         end else begin
            reg_rdata[31:0] <= 32'd0;
         end
      end
   end

   assign LOCAL_ACK         = (wr_ack | rd_ack);
   assign LOCAL_RDATA[31:0] = reg_rdata[31:0];

   assign GPIO_OT           = reg_gpio_o;

endmodule