module top_module(
  input  wire           clk,
  input  wire           tg68_as,
  input  wire [ 32-1:0] tg68_adr,
  input  wire           tg68_rw,
  input  wire           tg68_lds,
  input  wire           tg68_uds,
  input  wire [ 16-1:0] tg68_dat_out,
  output wire [ 16-1:0] tg68_dat_in,
  output wire           tg68_dtack
);// memory
reg  [8-1:0] mem0 [0:512-1];
reg  [8-1:0] mem1 [0:512-1];

// internal signals
reg  [16-1:0] mem_do = 0;
reg           trn = 1;
reg           ack = 1;

// clear on start
integer i;
initial begin
  for (i=0; i<512; i=i+1) begin
    mem1[i] = 0;
    mem0[i] = 0;
  end
end

// read
always @ (posedge clk) begin
  if (!tg68_as && tg68_rw) mem_do <= #1 {mem1[tg68_adr[31:1]], mem0[tg68_adr[31:1]]};
end

//write
always @ (posedge clk) begin
  if (!tg68_as && !tg68_rw) begin
    if (!tg68_uds) mem1[tg68_adr[31:1]] <= #1 tg68_dat_out[15:8];
    if (!tg68_lds) mem0[tg68_adr[31:1]] <= #1 tg68_dat_out[7:0];
  end
end

// acknowledge
always @ (posedge clk) begin
  trn <= #1 tg68_as;
  ack <= #1 trn;
end

// outputs
assign tg68_dat_in = mem_do;
assign tg68_dtack = ack || tg68_as;

endmodule