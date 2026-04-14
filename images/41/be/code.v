module top_module(
    input A, DDRDEL, LOADN, MOVE, DIRECTION,
    output reg Z, CFLAG
);parameter DEL_ADJ = "PLUS";
    parameter DEL_VAL = 0;
    parameter DELAY_SIZE = 4;

    reg [DELAY_SIZE-1:0] delay_line;
    reg [DELAY_SIZE-1:0] delay_line_next;

    assign Z = DDRDEL ? delay_line[DELAY_SIZE-1] : A;

    always @(*) begin
        delay_line_next = delay_line;
        CFLAG = 0; // Initialize CFLAG
        if (LOADN == 0) begin
            delay_line_next[0] = A;
        end
        if (MOVE == 1) begin
            delay_line_next[0] = A;
        end
        if (DIRECTION == "PLUS") begin
            if (DEL_ADJ == "PLUS") begin
                delay_line_next = {delay_line[DELAY_SIZE-2:0], delay_line[DELAY_SIZE-1]+DEL_VAL};
            end else begin
                delay_line_next = {delay_line[DELAY_SIZE-2:0], delay_line[DELAY_SIZE-1]-DEL_VAL};
            end
        end else begin
            if (DEL_ADJ == "PLUS") begin
                delay_line_next = {delay_line[DELAY_SIZE-2:0], delay_line[DELAY_SIZE-1]-DEL_VAL};
            end else begin
                delay_line_next = {delay_line[DELAY_SIZE-2:0], delay_line[DELAY_SIZE-1]+DEL_VAL};
            end
        end
        if (delay_line_next[DELAY_SIZE-1] != delay_line[DELAY_SIZE-1]) begin
            CFLAG = 1;
        end
    end

    always @(posedge DDRDEL) begin
        delay_line <= delay_line_next;
    end

endmodule