module top_module(clk, reset, penny, nickel, dime, quarter, apple, banana, carrot, date, credit);input clk, reset;
input penny, nickel, dime, quarter;
input apple, banana, carrot, date;
output reg [7:0] credit;

always@(posedge clk)begin
if(reset)begin
	credit <= 0;
end else begin
	if(penny)begin
		credit <= (credit + 1 > 255) ? 255 : credit + 1;
	end if(nickel) begin
		credit <= (credit + 5 > 255) ? 255 : credit + 5;
	end if(dime) begin
		credit <= (credit + 10 > 255) ? 255 : credit + 10;
	end if(quarter) begin
		credit <= (credit + 25 > 255) ? 255 : credit + 25;
	end if(apple) begin
		credit <= credit - 75;
	end if(banana) begin
		credit <= credit - 20;
	end if(carrot) begin
		credit <= credit - 30;
	end if(date) begin
		credit <= credit - 40;
	end
end
end
endmodule