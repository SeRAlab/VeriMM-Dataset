module top_module(
        input         clk,
        input         rst,
        input         hwrite,
        input [31:0]  hwdata,
        input [31:0]  haddr,
        input         hsel,
        output reg[31:0]  hrdata,

        output[127:0] data,
        input [127:0] ro_data
);reg[15:0] dataA[7:0];

assign data = {dataA[7], dataA[6], dataA[5], dataA[4],
	dataA[3], dataA[2], dataA[1], dataA[0]};

wire[15:0] rodataA[7:0];

assign {rodataA[7], rodataA[6], rodataA[5], rodataA[4],
	rodataA[3], rodataA[2], rodataA[1], rodataA[0]} = {
	ro_data[127:112], ro_data[111:96],
	ro_data[95 :80],  ro_data[79:64],
	ro_data[63 :48],  ro_data[47:32],
	ro_data[31 :16],  ro_data[15:0]
};

reg ctr;
reg write;

wire[2:0] raddr = haddr[4:2];

always @(*) begin
	if (haddr[15:0] >= 'h20 && haddr[15:0] < 'h40) begin
		hrdata = rodataA[raddr];
	end else if (haddr[15:0] < 'h20) begin
		hrdata = dataA[raddr];
	end else begin
                hrdata = 0;
        end
end

always @(posedge clk) begin
	if (rst) begin
		ctr <= 0;
		write <= 0;
	end else if (ctr) begin
		ctr <= 0;
		if (write && haddr[15:0] < 'h20)
			dataA[raddr] <= hwdata;
	end else begin
		ctr   <= hsel;
		write <= hwrite;
	end
end

endmodule