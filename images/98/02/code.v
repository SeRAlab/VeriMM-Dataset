module top_module(
	
	request_mask_pa,

	
	rclk,
	reset_l,

	pcx_req_pa,
	pcx_req_px,
	pcx_atom_px,

	pcx_grant_px
	);output request_mask_pa;

    input rclk;
    input reset_l;

    input pcx_req_pa;
    input pcx_req_px;
    input pcx_atom_px;

    input pcx_grant_px;


    reg [1:0] link_count_pa;
    wire      request_mask_pa;
    wire      count_inc;
    wire      count_dec;

    assign count_inc = pcx_req_pa || (pcx_req_px && pcx_atom_px);
    assign count_dec = pcx_grant_px;


    always @(posedge rclk) begin
	if (!reset_l) begin
	    link_count_pa <= 2'b00;
	end
	else if (count_inc && count_dec) begin
	    link_count_pa <= link_count_pa;
	end
	else if (count_inc && !link_count_pa[1]) begin
	    link_count_pa <= link_count_pa + 2'b01;
	end
	else if (count_dec) begin
	    link_count_pa <= link_count_pa - 2'b01;
	end
	else begin
	    link_count_pa <= link_count_pa;
	end
    end

    assign request_mask_pa = link_count_pa[1];

endmodule