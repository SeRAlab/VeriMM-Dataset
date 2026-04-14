module top_module(
           input I_clk,

           input I_reg_we,
           input [4:0] I_rs_addr,
           input [4:0] I_rt_addr,
           input [4:0] I_wb_addr,
           input [31:0] I_wb_data,

           output [31:0] O_rs_data,
           output [31:0] O_rt_data
       );reg [31:0] R_gpr[31:0];

always @(posedge I_clk) begin
    if(I_reg_we) begin
        R_gpr[I_wb_addr]<=I_wb_data;
    end
end

assign O_rs_data=(I_rs_addr==0)?32'h0:R_gpr[I_rs_addr];
assign O_rt_data=(I_rt_addr==0)?32'h0:R_gpr[I_rt_addr];

endmodule