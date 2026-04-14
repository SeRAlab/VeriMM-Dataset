module top_module(
    input wire 			rst,

	input wire			stall_req_from_if,
	input wire			stall_req_from_id,
	input wire			stall_req_from_ex,
	input wire			stall_req_from_me,

	output reg[5:0]		stall
);always @ (*)
	begin
		if (rst)
		begin
			stall	<=	6'b000000;
		end

        else if (stall_req_from_if)
        begin
			stall	<=	6'b000011;
        end

        else if (stall_req_from_id)
        begin
			stall	<=	6'b000111;
        end

        else if (stall_req_from_ex)
        begin
			stall	<=	6'b001111;
        end

		else if (stall_req_from_me)
        begin
			stall	<=	6'b011111;
        end

		else begin
			stall	<=	6'b000000;
        end
	end


endmodule