module top_module(
  input             clk,
  input             rst,
  input             i_wbs_cyc,
  input             i_wbs_stb,
  input      [31:0] i_wbs_adr,
  input      [31:0] i_wbs_dat,
  input             i_wbs_we,
  output reg [31:0] o_wbs_dat,
  output reg        o_wbs_ack,
  output reg        o_wbs_int
);//Local Parameters
  localparam     ADDR_0  = 32'h00000000;
  localparam     ADDR_1  = 32'h00000001;
  localparam     ADDR_2  = 32'h00000002;

  //Local Registers/Wires
  reg [31:0]     addr_reg;
  reg            write_reg;
  reg            ack_reg;

  //Asynchronous Logic
  always @(*) begin
    case (i_wbs_adr)
      24'h0000FF: begin
        o_wbs_int     =  0;
      end
      24'h001000: begin
        o_wbs_int     =  i_wbs_dat[0];
      end
      default: begin
      end
    endcase
  end

  //Synchronous Logic
  always @(posedge clk) begin
    if (rst) begin
      addr_reg <= 32'h0;
      write_reg <= 0;
      ack_reg <= 0;
      o_wbs_dat <= 32'h0;
      o_wbs_ack <= 0;
      o_wbs_int <= 0;
    end

    else begin
      //when the master acks our ack, then put our ack down
      if (ack_reg && ~i_wbs_stb)begin
        o_wbs_ack <= 0;
      end

      if (i_wbs_stb && i_wbs_cyc) begin
        //master is requesting something
        if (!ack_reg) begin
          if (i_wbs_we) begin
            //write request
            addr_reg <= i_wbs_adr;
            write_reg <= i_wbs_dat[0];
            ack_reg <= 1;
          end
          else begin
            //read request
            o_wbs_dat <= addr_reg;
            ack_reg <= 1;
          end
        end
        o_wbs_ack <= 1;
      end
    end
  end

endmodule