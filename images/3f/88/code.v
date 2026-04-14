module sha256_compression(
    input [511:0] message,
    input [255:0] state,
    output reg [255:0] new_state
);
    // SHA-256 constants
    reg [31:0] K [0:63];
    integer i;

    initial begin
        K[0] = 32'h428a2f98; K[1] = 32'h71374491; K[2] = 32'hb5c0fbcf; K[3] = 32'he9b5dba5;
        K[4] = 32'h3956c25b; K[5] = 32'h59f111f1; K[6] = 32'h923f82a4; K[7] = 32'hab1c5ed5;
        K[8] = 32'hd807aa98; K[9] = 32'h12835b01; K[10] = 32'h243185be; K[11] = 32'h550c7dc3;
        K[12] = 32'h72be5d74; K[13] = 32'h80deb1fe; K[14] = 32'h9bdc06a7; K[15] = 32'hc19bf174;
        K[16] = 32'he49b69c1; K[17] = 32'hefbe4786; K[18] = 32'h0fc19dc6; K[19] = 32'h240ca1cc;
        K[20] = 32'h2de92c6f; K[21] = 32'h4a7484aa; K[22] = 32'h5cb0a9dc; K[23] = 32'h76f988da;
        K[24] = 32'h983e5152; K[25] = 32'ha831c66d; K[26] = 32'hb00327c8; K[27] = 32'hbf597fc7;
        K[28] = 32'hc6e00bf3; K[29] = 32'hd5a79147; K[30] = 32'h06ca6351; K[31] = 32'h14292967;
        K[32] = 32'h27b70a85; K[33] = 32'h2e1b2138; K[34] = 32'h4d2c6dfc; K[35] = 32'h53380d13;
        K[36] = 32'h650a7354; K[37] = 32'h766a0abb; K[38] = 32'h81c2c92e; K[39] = 32'h92722c85;
        K[40] = 32'ha2bfe8a1; K[41] = 32'ha81a664b; K[42] = 32'hc24b8b70; K[43] = 32'hc76c51a3;
        K[44] = 32'hd192e819; K[45] = 32'hd6990624; K[46] = 32'hf40e3585; K[47] = 32'h106aa070;
        K[48] = 32'h19b4c7c0; K[49] = 32'h1e376c48; K[50] = 32'h2748774c; K[51] = 32'h34b0bcb5;
        K[52] = 32'h391c0cb3; K[53] = 32'h4ed8aa4a; K[54] = 32'h5b9cca4f; K[55] = 32'h682e6ff3;
        K[56] = 32'h748f82ee; K[57] = 32'h78a5636f; K[58] = 32'h84c87814; K[59] = 32'h8cc70208;
        K[60] = 32'h90befffa; K[61] = 32'ha4506ceb; K[62] = 32'hbeefb0f8; K[63] = 32'hc67178f2;
    end

    // Message schedule
    reg [31:0] W [0:63];
    reg [31:0] a, b, c, d, e, f, g, h, temp1, temp2;

    always @(message or state) begin
        // Initialize the working variables with the current state
        a = state[255:224];
        b = state[223:192];
        c = state[191:160];
        d = state[159:128];
        e = state[127:96];
        f = state[95:64];
        g = state[63:32];
        h = state[31:0];

        // Prepare the message schedule
        for (i = 0; i < 16; i = i + 1) begin
            W[i] = message[i*32 +: 32];
        end
        for (i = 16; i < 64; i = i + 1) begin
            W[i] = W[i-16] + (W[i-15] >> 7) + (W[i-15] >> 18) + (W[i-15] >> 3) + W[i-7] + (W[i-2] >> 17) + (W[i-2] >> 19) + (W[i-2] >> 10);
        end

        // Compression function main loop
        for (i = 0; i < 64; i = i + 1) begin
            temp1 = h + ((e >> 6) ^ (e >> 11) ^ (e >> 25)) + ((e & f) ^ (~e & g)) + K[i] + W[i];
            temp2 = ((a >> 2) ^ (a >> 13) ^ (a >> 22)) + ((a & b) ^ (a & c) ^ (b & c));
            h = g;
            g = f;
            f = e;
            e = d + temp1;
            d = c;
            c = b;
            b = a;
            a = temp1 + temp2;
        end

        // Output the new state
        new_state = state + {a, b, c, d, e, f, g, h};
    end
endmodule