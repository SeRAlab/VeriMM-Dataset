module top_module(
                data_in,
                encode_out,
                enable_out
                );parameter   WIDTH       = 64;
parameter   N           = log2(WIDTH);

input   [WIDTH-1:0]     data_in;
output  [N-1:0]         encode_out;
output                  enable_out;

reg     [N-1:0]         encode_out;
reg                     enable_out;

reg     [N-1:0]         x;

integer i, j;

always @(*)
begin
    j = 0;
    for (i=0; i < WIDTH; i=i+1)
        if (data_in[i] == 1'b1)
            j = i;
            
    encode_out  = j;
    enable_out  = |{data_in};
end

function integer log2;
input [31:0] depth;
integer k;
begin
    log2 = 1;
    for (k=0; 2**k < depth; k=k+1)
        log2 = k + 1;
end
endfunction     

endmodule