module top_module(
	clk,
	load,
    en,
	data_in,
	ser
	);parameter DATA_WIDTH = 32;
	input clk;
	input load;
    input en;
	input [DATA_WIDTH-1:0] data_in;

	output reg ser;

	reg [DATA_WIDTH-1:0] data_reg;

    wire ser_tmp = data_reg[DATA_WIDTH-1];
	always @ (posedge clk or posedge load) begin
		if (load) begin
			data_reg <= data_in;
		end	else begin
            #8; 
			data_reg = {data_reg[DATA_WIDTH-2:0], 1'b0};
		end
	end

    always @ (*) begin
        if (en) begin
            ser = ser_tmp;
        end else begin
            ser = 1'b0;
        end
    end

endmodule