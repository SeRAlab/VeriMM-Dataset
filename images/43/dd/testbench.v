`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] a;
    reg ce;
    reg clk;
    reg [63:0] data;
    wire [63:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .ce(ce),
        .clk(clk),
        .data(data),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ce <= 1;
            data <= 64'd0;
            a <= 0;
            repeat(4) @(posedge clk);
            ce <= 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 001: Loading 4 values, reading newest (a=0)");

            @(negedge clk); ce <= 1; data <= 64'hAAAA_AAAA_AAAA_AAAA;
            @(negedge clk); ce <= 1; data <= 64'hBBBB_BBBB_BBBB_BBBB;
            @(negedge clk); ce <= 1; data <= 64'hCCCC_CCCC_CCCC_CCCC;
            @(negedge clk); ce <= 1; data <= 64'hDDDD_DDDD_DDDD_DDDD;
            @(negedge clk); ce <= 0; a <= 2'd0;

            #1;
            #1;

            check_outputs(64'hDDDD_DDDD_DDDD_DDDD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 002: Loading 4 values, reading oldest (a=3)");

            @(negedge clk); ce <= 1; data <= 64'h1111_1111_1111_1111;
            @(negedge clk); ce <= 1; data <= 64'h2222_2222_2222_2222;
            @(negedge clk); ce <= 1; data <= 64'h3333_3333_3333_3333;
            @(negedge clk); ce <= 1; data <= 64'h4444_4444_4444_4444;
            @(negedge clk); ce <= 0; a <= 2'd3;

            #1;
            #1;

            check_outputs(64'h1111_1111_1111_1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 003: Testing Chip Enable (ce) behavior");

            @(negedge clk); ce <= 1; data <= 64'h1234_5678_9ABC_DEF0;
            @(negedge clk); ce <= 0; data <= 64'hFFFF_FFFF_FFFF_FFFF;
            @(negedge clk); ce <= 1; data <= 64'hFEED_FACE_CAFE_BEEF;
            @(negedge clk); ce <= 0; a <= 2'd1;

            #1;

            #1;


            check_outputs(64'h1234_5678_9ABC_DEF0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 004: Shifting 5 values (overflow oldest)");

            @(negedge clk); ce <= 1; data <= 64'h0000_0000_0000_0001;
            @(negedge clk); ce <= 1; data <= 64'h0000_0000_0000_0002;
            @(negedge clk); ce <= 1; data <= 64'h0000_0000_0000_0003;
            @(negedge clk); ce <= 1; data <= 64'h0000_0000_0000_0004;
            @(negedge clk); ce <= 1; data <= 64'h0000_0000_0000_0005;
            @(negedge clk); ce <= 0; a <= 2'd3;

            #1;

            #1;


            check_outputs(64'h0000_0000_0000_0002);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 005: Reading from middle address (a=2)");

            @(negedge clk); ce <= 1; data <= 64'hDEAF_BEEF_0000_0001;
            @(negedge clk); ce <= 1; data <= 64'hDEAF_BEEF_0000_0002;
            @(negedge clk); ce <= 1; data <= 64'hDEAF_BEEF_0000_0003;
            @(negedge clk); ce <= 1; data <= 64'hDEAF_BEEF_0000_0004;
            @(negedge clk); ce <= 0; a <= 2'd2;

            #1;
            #1;

            check_outputs(64'hDEAF_BEEF_0000_0002);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [63:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,a, ce, clk, data, q);
    end

endmodule
