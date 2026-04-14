module top_module(
    clk, 
    rst, 
    controls_in, 
    from_mem_data_in, 
    from_alu_data_in, 
    regfile_addr_in, 
    controls_out, 
    from_mem_data_out, 
    from_alu_data_out, 
    regfile_addr_out
);input clk;
input rst;
input [2:0] controls_in;
input [31:0] from_mem_data_in;
input [31:0] from_alu_data_in;
input [4:0] regfile_addr_in;
output [2:0] controls_out;
output [31:0] from_mem_data_out;
output [31:0] from_alu_data_out;
output [4:0] regfile_addr_out;

wire N3;
wire N4;
wire N5;
wire N70;
wire N71;
wire N72;
wire N73;
wire N74;
wire n74;

// Instantiate D flip-flop
reg [2:0] controls_out_reg;
reg [31:0] from_mem_data_out_reg;
reg [31:0] from_alu_data_out_reg;
reg [4:0] regfile_addr_out_reg;

// D Flip-Flops for controls_out
always @(posedge clk or posedge rst) begin
    if (rst) 
        controls_out_reg <= 3'b0;
    else 
        controls_out_reg <= controls_in;
end
assign controls_out = controls_out_reg;

// D Flip-Flop for from_mem_data_out
always @(posedge clk or posedge rst) begin
    if (rst) 
        from_mem_data_out_reg <= 32'b0;
    else 
        from_mem_data_out_reg <= from_mem_data_in;
end
assign from_mem_data_out = from_mem_data_out_reg;

// D Flip-Flop for from_alu_data_out
always @(posedge clk or posedge rst) begin
    if (rst) 
        from_alu_data_out_reg <= 32'b0;
    else 
        from_alu_data_out_reg <= from_alu_data_in;
end
assign from_alu_data_out = from_alu_data_out_reg;

// Inversion for reset
assign n74 = ~rst;

// AND gates for regfile_addr_out
assign N70 = n74 & regfile_addr_in[0];
assign N71 = n74 & regfile_addr_in[1];
assign N72 = n74 & regfile_addr_in[2];
assign N73 = n74 & regfile_addr_in[3];
assign N74 = n74 & regfile_addr_in[4];

// D Flip-Flop for regfile_addr_out
always @(posedge clk or posedge rst) begin
    if (rst) 
        regfile_addr_out_reg <= 5'b0;
    else 
        regfile_addr_out_reg <= {N74, N73, N72, N71, N70};
end
assign regfile_addr_out = regfile_addr_out_reg;

endmodule