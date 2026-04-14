`timescale 1ns/1ps

module add_numbers_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] binary_num1;
    reg [3:0] binary_num2;
    reg clk;
    reg reset;
    wire [4:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    add_numbers_module dut (
        .binary_num1(binary_num1),
        .binary_num2(binary_num2),
        .clk(clk),
        .reset(reset),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            binary_num1 = 0;
            binary_num2 = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Addition (5 + 3)", test_num);
            reset_dut();
            binary_num1 = 4'd5;
            binary_num2 = 4'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum 4-bit Values (15 + 15)", test_num);
            reset_dut();
            binary_num1 = 4'd15;
            binary_num2 = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Addition (0 + 0)", test_num);
            reset_dut();
            binary_num1 = 4'd0;
            binary_num2 = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Value (15 + 0)", test_num);
            reset_dut();
            binary_num1 = 4'd15;
            binary_num2 = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Result crossing 4-bit limit (8 + 8)", test_num);
            reset_dut();
            binary_num1 = 4'd8;
            binary_num2 = 4'd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd16);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Synchronous Reset Check", test_num);
            reset_dut();
            binary_num1 = 4'd10;
            binary_num2 = 4'd5;
            @(posedge clk);
            #1;

            if (sum !== 5'd15) begin
                $display("FAIL: Pre-reset check failed");
                fail_count = fail_count + 1;
            end else begin

                reset = 1;
                @(posedge clk);
                #1;
                #1;

                check_outputs(5'd0);
                reset = 0;
            end
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition with 1 (1 + 1)", test_num);
            reset_dut();
            binary_num1 = 4'd1;
            binary_num2 = 4'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("add_numbers_module Testbench");
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
        input [4:0] expected_sum;
        begin
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
        $dumpvars(0,binary_num1, binary_num2, clk, reset, sum);
    end

endmodule
