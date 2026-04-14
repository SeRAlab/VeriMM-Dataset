module top_module(
  input [w-1:0] va,
  input [2**w-1:0] pt,
  input [w-1:0] pba,
  output reg [w-1:0] pa,
  output reg valid
);parameter w = 8; // width of virtual and physical addresses

reg [w-1:0] vpn; // virtual page number
reg [w-1:0] pfn; // physical frame number
reg [w-1:0] offset; // page offset
reg [w-1:0] pte; // page table entry

// Function to calculate log2
function integer log2;
  input integer value;
  begin
    log2 = 0;
    while (2**log2 < value) begin
      log2 = log2 + 1;
    end
  end
endfunction

always @(*) begin
  vpn = va[w-1: w-log2(w)]; // extract virtual page number
  offset = va[w-log2(w)-1:0]; // extract page offset

  pte = pt[vpn]; // retrieve page table entry
  if (pte == 0) begin
    valid = 0; // invalid page table entry
  end else begin
    valid = 1; // valid page table entry
    pfn = pte; // retrieve physical frame number
    pa = {pfn, offset}; // concatenate physical frame number and page offset
  end
end

endmodule