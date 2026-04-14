module top_module(
	input usb_clk,

	input rcv,
	input vp,
	input vm,

	output reg rcv_s,
	output reg vp_s,
	output reg vm_s
);reg rcv_s0;
reg vp_s0;
reg vm_s0;
reg rcv_s1;
reg vp_s1;
reg vm_s1;


always @(posedge usb_clk) begin
	rcv_s0 <= rcv;
	vp_s0 <= vp;
	vm_s0 <= vm;
	rcv_s <= rcv_s0;
	vp_s <= vp_s0;
	vm_s <= vm_s0;
end




endmodule