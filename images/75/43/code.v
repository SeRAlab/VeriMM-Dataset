module mux4to1 (
    input d0,
    input d1,
    input d2,
    input d3,
    input sel0,
    input sel1,
    output y);
assign y = (sel1) ? ((sel0) ? d3 : d2) : ((sel0) ? d1 : d0);
endmodule