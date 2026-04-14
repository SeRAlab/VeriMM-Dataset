`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] a;
    reg [11:0] b;
    reg ce;
    reg clk;
    wire [21:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ce(ce),
        .clk(clk),
        .p(p)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            ce = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 10'd25;
            b = 12'd40;
            ce = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Positive * Positive (25 * 40)", test_num);
            #1;

            check_outputs(22'd1000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = -10'd15;
            b = 12'd100;
            ce = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Negative * Positive (-15 * 100)", test_num);
            #1;

            check_outputs(-22'd1500);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 10'd50;
            b = -12'd20;
            ce = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Positive * Negative (50 * -20)", test_num);
            #1;

            check_outputs(-22'd1000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = -10'd30;
            b = -12'd30;
            ce = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Negative * Negative (-30 * -30)", test_num);
            #1;

            check_outputs(22'd900);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 10'd0;
            b = -12'd500;
            ce = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Zero input (0 * -500)", test_num);
            #1;

            check_outputs(22'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 10'h1FF;
            b = 12'h7FF;
            ce = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Max Positive (511 * 2047)", test_num);
            #1;

            check_outputs(22'sd511 * 22'sd2047);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 10'h200;
            b = 12'h800;
            ce = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Min Negative (-512 * -2048)", test_num);
            #1;

            check_outputs(22'sd1048576);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();

            a = 10'd5;
            b = 12'd5;
            ce = 1;
            @(posedge clk);
            #1;

            a = 10'd10;
            b = 12'd10;
            ce = 0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Clock Enable check (ce=0, output should hold 25)", test_num);
            #1;

            check_outputs(22'd25);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 10'h200;
            b = 12'h7FF;
            ce = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Min Negative * Max Positive (-512 * 2047)", test_num);
            #1;

            check_outputs(-22'sd1048064);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            reset_dut();

            a = 10'd12;
            b = 12'd12;
            ce = 0;
            @(posedge clk);
            #1;

            ce = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Verify recovery after ce disabled", test_num);
            #1;

            check_outputs(22'd144);
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
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [21:0] expected_p;
        begin
            if (expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: p=%h",
                         p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h",
                         expected_p);
                $display("  Got:      p=%h",
                         p);
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
        $dumpvars(0,a, b, ce, clk, p);
    end

endmodule
