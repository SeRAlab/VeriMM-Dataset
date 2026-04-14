module top_module(
		input wire rstreghours,
		input wire clk,
		input wire leerhours, escribirhours,
		input wire lrda, lrdb, lrdc, lrdd, lrde, lrdf, lrdg, lrdh,
		input wire [3:0] htens,
		input wire [3:0] hones,
		output reg [3:0] hour1,
		output reg [3:0] hour2
    );always @(posedge clk) begin
	if (leerhours) begin
		if (rstreghours) begin
			hour1 <= 0;
			hour2 <= 0;
		end
		else begin
			hour1[3] <= lrda;
			hour1[2] <= lrdb;
			hour1[1] <= lrdc;
			hour1[0] <= lrdd;
			hour2[3] <= lrde;
			hour2[2] <= lrdf;
			hour2[1] <= lrdg;
			hour2[0] <= lrdh;
		end
	end
	else if (escribirhours) begin
		if (rstreghours) begin
			hour1 <= 0;
			hour2 <= 0;
		end
		else begin
			hour1 <= htens;
			hour2 <= hones;
		end
	end
end

endmodule