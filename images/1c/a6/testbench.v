`timescale 1ns/1ps

module chacha_quarter_round_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] c;
    reg clk;
    reg [31:0] d;
    wire [31:0] out_a;
    wire [31:0] out_b;
    wire [31:0] out_c;
    wire [31:0] out_d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha_quarter_round dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .d(d),
        .out_a(out_a),
        .out_b(out_b),
        .out_c(out_c),
        .out_d(out_d)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        a = 32'h0;
        b = 32'h0;
        c = 32'h0;
        d = 32'h0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Test Case 001: All Zeros");
        a = 32'h0; b = 32'h0; c = 32'h0; d = 32'h0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Test Case 002: Standard Constant Vectors");

        a = 32'h11111111;
        b = 32'h01020304;
        c = 32'h9b8d6f43;
        d = 32'h01234567;
        @(posedge clk);
        #1;


        #1;



        check_outputs(32'hea2a92f4, 32'h4b1cf8ce, 32'h4581472e, 32'h5881c4bb);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Test Case 003: Simple Ones");
        a = 32'h1; b = 32'h1; c = 32'h1; d = 32'h1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(32'h30000002, 32'h81811899, 32'h03030231, 32'h03000230);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Test Case 004: Max Values (Overflow Test)");
        a = 32'hffffffff; b = 32'hffffffff; c = 32'hffffffff; d = 32'hffffffff;
        @(posedge clk);
        #1;


        #1;



        check_outputs(32'heffffffd, 32'h78783087, 32'hff00ff9e, 32'hfeffffaf);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Test Case 005: Alternating Bits");
        a = 32'haaaaaaaa; b = 32'h55555555; c = 32'haaaaaaaa; d = 32'h55555555;
        @(posedge clk);
        #1;


        #1;



        check_outputs(32'h00000fff, 32'h0575ff00, 32'h000afbfe, 32'haab5a5aa);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha_quarter_round Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [31:0] expected_out_a;
        input [31:0] expected_out_b;
        input [31:0] expected_out_c;
        input [31:0] expected_out_d;
        begin
            if (expected_out_a === (expected_out_a ^ out_a ^ expected_out_a) &&
                expected_out_b === (expected_out_b ^ out_b ^ expected_out_b) &&
                expected_out_c === (expected_out_c ^ out_c ^ expected_out_c) &&
                expected_out_d === (expected_out_d ^ out_d ^ expected_out_d)) begin
                $display("PASS");
                $display("  Outputs: out_a=%h, out_b=%h, out_c=%h, out_d=%h",
                         out_a, out_b, out_c, out_d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_a=%h, out_b=%h, out_c=%h, out_d=%h",
                         expected_out_a, expected_out_b, expected_out_c, expected_out_d);
                $display("  Got:      out_a=%h, out_b=%h, out_c=%h, out_d=%h",
                         out_a, out_b, out_c, out_d);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,a, b, c, clk, d, out_a, out_b, out_c, out_d);
    end

endmodule
