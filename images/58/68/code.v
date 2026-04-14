module top_module(
    input wire [10:0] bin,
    output reg [3:0] ones,
    output reg [3:0] tens,
    output reg [3:0] hundreds,
    output reg [3:0] thousands
);parameter THOU = 1000;
parameter HUND = 100;
parameter TENS = 10;
parameter ONES = 1;

reg [10:0] buffer;
integer i;
integer sub;

always @ (*)
begin
	buffer = bin;
	ones = 4'd0;
    tens = 4'd0;
    hundreds = 4'd0;
    thousands = 4'd0;
    sub = 0;
     if(buffer >= THOU) begin
     	for(i = 0; i < 10; i = i + 1) begin
     		if(i*THOU < buffer) begin
     			sub = sub + 1;
     		end
     	end
 		if(buffer < sub*THOU) begin
 			sub = sub - 1;
 		end
     	buffer = buffer - sub*THOU;
     	thousands = sub;
     end
     sub = 0;
     if(buffer >= HUND) begin
     	for(i = 0; i < 10; i = i + 1) begin
     		if(i*HUND < buffer) begin
     			sub = sub + 1;
     		end
     	end
 		if(buffer < sub*HUND) begin
 			sub = sub - 1;
 		end
     	buffer = buffer - sub*HUND;
     	hundreds = sub;
     end
     sub = 0;
     if(buffer >= TENS) begin
     	for(i = 0; i < 10; i = i + 1) begin
     		if(i*TENS < buffer) begin
     			sub = sub + 1;
     		end
     	end
 		if(buffer < sub*TENS) begin
 			sub = sub - 1;
 		end
     	buffer = buffer - sub*TENS;
     	tens = sub;
     end
     sub = 0;
     if(buffer >= ONES) begin
     	for(i = 0; i < 10; i = i + 1) begin
     		if(i*ONES < buffer) begin
     			sub = sub + 1;
     		end
     	end
 		if(buffer < sub) begin
 			sub = sub - 1;
 		end
     	buffer = buffer - sub;
     	ones = sub;
     end
end

endmodule