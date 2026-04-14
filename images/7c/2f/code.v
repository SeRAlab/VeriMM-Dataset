module top_module(
    input io_addr_read,
    input [3:0] io_addr,
    output [15:0] d_addr
    );wire [15:0] encoded_addr;
	assign d_addr = io_addr_read ? encoded_addr : 16'bz;
	
	assign encoded_addr[ 0] = (io_addr ==  0);
	assign encoded_addr[ 1] = (io_addr ==  1);
	assign encoded_addr[ 2] = (io_addr ==  2);
	assign encoded_addr[ 3] = (io_addr ==  3);
	assign encoded_addr[ 4] = (io_addr ==  4);
	assign encoded_addr[ 5] = (io_addr ==  5);
	assign encoded_addr[ 6] = (io_addr ==  6);
	assign encoded_addr[ 7] = (io_addr ==  7);
	assign encoded_addr[ 8] = (io_addr ==  8);
	assign encoded_addr[ 9] = (io_addr ==  9);
	assign encoded_addr[10] = (io_addr == 10);
	assign encoded_addr[11] = (io_addr == 11);
	assign encoded_addr[12] = (io_addr == 12);
	assign encoded_addr[13] = (io_addr == 13);
	assign encoded_addr[14] = (io_addr == 14);
	assign encoded_addr[15] = (io_addr == 15);
	
endmodule