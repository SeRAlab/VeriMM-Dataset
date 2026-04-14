module top_module(
    input req_a,
    input req_b,
    input req_c,
    output reg grant
);always @(*) begin
    if(req_a && !req_b && !req_c) begin
        grant = 1;
    end
    else if(!req_a && req_b && !req_c) begin
        grant = 1;
    end
    else if(!req_a && !req_b && req_c) begin
        grant = 1;
    end
    else if(req_a && req_b && !req_c) begin
        grant = 1;
    end
    else if(req_a && !req_b && req_c) begin
        grant = 1;
    end
    else if(!req_a && req_b && req_c) begin
        grant = 1;
    end
    else begin
        grant = 0;
    end
end

endmodule