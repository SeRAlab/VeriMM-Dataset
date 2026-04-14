`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ena;
    reg [42:0] radical;
    wire [21:0] q;
    wire [22:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ena(ena),
        .radical(radical),
        .q(q),
        .remainder(remainder)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ena = 0;
            radical = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Radical = 0", test_num);
            reset_dut();
            radical = 43'd0;
            ena = 1;
            repeat (50) @(posedge clk);
            ena = 0;
            #1;

            check_outputs(22'd0, 23'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Radical = 100 (10^2)", test_num);
            reset_dut();
            radical = 43'd100;
            ena = 1;
            repeat (50) @(posedge clk);
            ena = 0;
            #1;

            check_outputs(22'd10, 23'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Radical = 2 (1^2 + 1)", test_num);
            reset_dut();
            radical = 43'd2;
            ena = 1;
            repeat (50) @(posedge clk);
            ena = 0;
            #1;

            check_outputs(22'd1, 23'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Radical = 2^43 - 1 (Max Input)", test_num);
            reset_dut();
            radical = 43'h7FFFFFFFFFF;
            ena = 1;
            repeat (50) @(posedge clk);
            ena = 0;
            #1;

            check_outputs(22'd2965820, 23'd4709807);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Radical = 1,000,000,000,000 (1,000,000^2)", test_num);
            reset_dut();
            radical = 43'd1000000000000;
            ena = 1;
            repeat (50) @(posedge clk);
            ena = 0;
            #1;

            check_outputs(22'd1000000, 23'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Radical = 2^32", test_num);
            reset_dut();
            radical = 43'h100000000;
            ena = 1;
            repeat (50) @(posedge clk);
            ena = 0;
            #1;

            check_outputs(22'd65536, 23'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Radical = 35 (5^2 + 10)", test_num);
            reset_dut();
            radical = 43'd35;
            ena = 1;
            repeat (50) @(posedge clk);
            ena = 0;
            #1;

            check_outputs(22'd5, 23'd10);
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
        input [21:0] expected_q;
        input [22:0] expected_remainder;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: q=%h, remainder=%h",
                         q, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, remainder=%h",
                         expected_q, expected_remainder);
                $display("  Got:      q=%h, remainder=%h",
                         q, remainder);
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
        $dumpvars(0,clk, ena, radical, q, remainder);
    end

endmodule
