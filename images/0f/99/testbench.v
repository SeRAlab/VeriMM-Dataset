`timescale 1ns/1ps

module quarter_round_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] c;
    reg clk;
    reg [31:0] d;
    wire [31:0] o_a;
    wire [31:0] o_b;
    wire [31:0] o_c;
    wire [31:0] o_d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    quarter_round dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .d(d),
        .o_a(o_a),
        .o_b(o_b),
        .o_c(o_c),
        .o_d(o_d)
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
            repeat(5) @(posedge clk);
            #1;

            check_outputs(32'h0, 32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case 002: RFC 8439 Vector");
            a = 32'h11111111;
            b = 32'h01020304;
            c = 32'h9b8d7c6a;
            d = 32'h55555555;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(32'h0e1e61f1, 32'h7f9b91e3, 32'h3af47aff, 32'h5e26b74f);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case 003: All Ones");
            a = 32'hffffffff;
            b = 32'hffffffff;
            c = 32'hffffffff;
            d = 32'hffffffff;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(32'hefff1ffd, 32'h9079080f, 32'hef20fdef, 32'hef1ffdef);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case 004: Minimal Values");
            a = 32'h1; b = 32'h1; c = 32'h1; d = 32'h1;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(32'h30000002, 32'h81811899, 32'h03030231, 32'h03000230);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case 005: Mixed Pattern");
            a = 32'h87654321;
            b = 32'h12345678;
            c = 32'hfedcba98;
            d = 32'h0fedcba9;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(32'h2a10ddcc, 32'h4b936e30, 32'h71590984, 32'h204bb878);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("quarter_round Testbench");
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
        input [31:0] expected_o_a;
        input [31:0] expected_o_b;
        input [31:0] expected_o_c;
        input [31:0] expected_o_d;
        begin
            if (expected_o_a === (expected_o_a ^ o_a ^ expected_o_a) &&
                expected_o_b === (expected_o_b ^ o_b ^ expected_o_b) &&
                expected_o_c === (expected_o_c ^ o_c ^ expected_o_c) &&
                expected_o_d === (expected_o_d ^ o_d ^ expected_o_d)) begin
                $display("PASS");
                $display("  Outputs: o_a=%h, o_b=%h, o_c=%h, o_d=%h",
                         o_a, o_b, o_c, o_d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_a=%h, o_b=%h, o_c=%h, o_d=%h",
                         expected_o_a, expected_o_b, expected_o_c, expected_o_d);
                $display("  Got:      o_a=%h, o_b=%h, o_c=%h, o_d=%h",
                         o_a, o_b, o_c, o_d);
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
        $dumpvars(0,a, b, c, clk, d, o_a, o_b, o_c, o_d);
    end

endmodule
