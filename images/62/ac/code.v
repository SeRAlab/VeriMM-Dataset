module top_module(

  mdio_mdc,
  mdio_in_w,
  mdio_in_r,

  speed_select,
  duplex_mode);parameter PHY_AD = 5'b10000;

  input           mdio_mdc;
  input           mdio_in_w;
  input           mdio_in_r;
  output  [ 1:0]  speed_select;
  output          duplex_mode;

  localparam IDLE     = 2'b01;
  localparam ACQUIRE  = 2'b10;

  wire        preamble;

  reg [ 1:0]  current_state = IDLE;
  reg [ 1:0]  next_state    = IDLE;
  reg [31:0]  data_in       = 32'h0;
  reg [31:0]  data_in_r     = 32'h0;
  reg [ 5:0]  data_counter  = 6'h0;
  reg [ 1:0]  speed_select  = 2'h0;
  reg         duplex_mode   = 1'h0;

  assign preamble = &data_in;

  always @(posedge mdio_mdc) begin
    current_state <= next_state;
    data_in <= {data_in[30:0], mdio_in_w};
    if (current_state == ACQUIRE) begin
      data_counter <= data_counter + 1;
    end else begin
      data_counter <= 0;
    end
    if (data_counter == 6'h1f) begin
      if (data_in[31] == 1'b0 && data_in[29:28]==2'b10 && data_in[27:23] == PHY_AD && data_in[22:18] == 5'h11) begin
        speed_select <= data_in_r[16:15] ;
        duplex_mode  <= data_in_r[14];
      end
    end
  end

  always @(negedge mdio_mdc) begin
    data_in_r <= {data_in_r[30:0], mdio_in_r};
  end

  always @(*) begin
    case (current_state)
      IDLE: begin
        if (preamble == 1 && mdio_in_w == 0) begin
          next_state <= ACQUIRE;
        end else begin
          next_state <= IDLE;
        end
      end
      ACQUIRE: begin
        if (data_counter == 6'h1f) begin
          next_state <= IDLE;
        end else begin
          next_state <= ACQUIRE;
        end
      end
      default: begin
        next_state <= IDLE;
      end
    endcase
  end

endmodule