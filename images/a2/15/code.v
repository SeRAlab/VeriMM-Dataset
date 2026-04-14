module top_module(DOUTB,
    clk,
    ENB,
    E,
    Q,
    ADDRB,
    ADDRA,
    din);output [35:0]DOUTB;
  input clk;
  input ENB;
  input [0:0]E;
  input [0:0]Q;
  input [5:0]ADDRB;
  input [5:0]ADDRA;
  input [35:0]din;

  reg [35:0] memory [0:63];
  reg [5:0] write_pointer = 0;
  reg [5:0] read_pointer = 0;
  wire [5:0]ADDRA;
  wire [5:0]ADDRB;
  wire [35:0]DOUTB;
  wire [0:0]E;
  wire ENB;
  wire [0:0]Q;
  wire clk;
  wire [35:0]din;

  assign ADDRA = read_pointer;
  assign ADDRB = write_pointer;
  assign DOUTB = memory[ADDRB];
  
  always @(posedge clk) begin
    if (ENB) begin
      if (E) begin
        memory[write_pointer] <= din;
        write_pointer <= write_pointer + 1;
      end else begin
        read_pointer <= read_pointer + 1;
      end
    end
  end

endmodule