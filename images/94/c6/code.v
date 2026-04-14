module top_module(input [31:0]A, input [31:0]B, input [3:0]op, output br);wire sgoe;
    wire sgne;
    wire sloe;
    wire slne;
    wire ugoe;
    wire ugne;
    wire uloe;
    wire ulne;
    wire e;
    wire ne;
    
    assign sgoe = ($signed(A)>=$signed(B));
    assign sgne = ($signed(A)>$signed(B));
    assign sloe = ($signed(A)<=$signed(B));
    assign slne = ($signed(A)<$signed(B));
    assign ugoe = ($signed(A)>=$signed(B));
    assign ugne = ($signed(A)>$signed(B));
    assign uloe = ($signed(A)<=$signed(B));
    assign ulne = ($unsigned(A)<$unsigned(B));
    
    assign e = (A==B);
    assign ne = ~e; 

    assign br = (ugoe&&op[1]&&op[0]&&~op[2]&&op[3])||(ugne&&op[3]&&~op[2]&&op[1]&&~op[0])||(uloe&&op[3]&&op[2]&&~op[1]&&op[0])||(ulne&&op[3]&&op[2]&&~op[1]&&~op[0])||(sgoe&&op[1]&&op[0]&&~op[2]&&~op[3])||(sgne&&~op[3]&&~op[2]&&op[1]&&~op[0])||(sloe&&~op[3]&&op[2]&&~op[1]&&op[0])||(slne&&~op[3]&&op[2]&&~op[1]&&~op[0])||(ne&&~op[3]&&~op[2]&&~op[1]&&~op[0])||(e&&~op[2]&&~op[1]&&op[0]);
endmodule