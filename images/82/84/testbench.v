`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] input1;
    reg [15:0] input2;
    wire equal;
    wire greater_than;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input1(input1),
        .input2(input2),
        .equal(equal),
        .greater_than(greater_than)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            input1 = 16'h0;
            input2 = 16'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            input1 = 16'h0000;
            input2 = 16'h0000;
            @(posedge clk);
            #2;
            $display("Test Case 001: Equality at Zero");
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            input1 = 16'hFFFF;
            input2 = 16'hFFFF;
            @(posedge clk);
            #2;
            $display("Test Case 002: Equality at Max Value");
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            input1 = 16'h0001;
            input2 = 16'h0000;
            @(posedge clk);
            #2;
            $display("Test Case 003: Input1 > Input2 (Small)");
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            input1 = 16'h0000;
            input2 = 16'h0001;
            @(posedge clk);
            #2;
            $display("Test Case 004: Input1 < Input2 (Small)");
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            input1 = 16'hFFFF;
            input2 = 16'h0000;
            @(posedge clk);
            #2;
            $display("Test Case 005: Input1 Max vs Input2 Zero");
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            input1 = 16'h0000;
            input2 = 16'hFFFF;
            @(posedge clk);
            #2;
            $display("Test Case 006: Input1 Zero vs Input2 Max");
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            input1 = 16'h8000;
            input2 = 16'h7FFF;
            @(posedge clk);
            #2;
            $display("Test Case 007: MSB Difference (GT)");
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            input1 = 16'hABCD;
            input2 = 16'hABCE;
            @(posedge clk);
            #2;
            $display("Test Case 008: LSB Difference (LT)");
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            input1 = 16'hAAAA;
            input2 = 16'hAAAA;
            @(posedge clk);
            #2;
            $display("Test Case 009: Alternating Bit Pattern Equality");
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            input1 = 16'h1234;
            input2 = 16'h4321;
            @(posedge clk);
            #2;
            $display("Test Case 010: Mid-range LT");
            #1;

            check_outputs(0, 0);
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
        input expected_equal;
        input expected_greater_than;
        begin
            if (expected_equal === (expected_equal ^ equal ^ expected_equal) &&
                expected_greater_than === (expected_greater_than ^ greater_than ^ expected_greater_than)) begin
                $display("PASS");
                $display("  Outputs: equal=%b, greater_than=%b",
                         equal, greater_than);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: equal=%b, greater_than=%b",
                         expected_equal, expected_greater_than);
                $display("  Got:      equal=%b, greater_than=%b",
                         equal, greater_than);
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
        $dumpvars(0,clk, input1, input2, equal, greater_than);
    end

endmodule
