module top_module(
    input branch,
    input branchIf,
    input brx,
    input z,
    input n,
    output result
    );assign result = (brx & branchIf & n) | (~brx & branchIf & z) | branch;
endmodule