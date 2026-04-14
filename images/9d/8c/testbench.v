`timescale 1ns/1ps

module bitwise_and_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] binary_num1;
    reg [3:0] binary_num2;
    reg clk;
    reg reset;
    wire [3:0] and_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bitwise_and_module dut (
        .binary_num1(binary_num1),
        .binary_num2(binary_num2),
        .clk(clk),
        .reset(reset),
        .and_result(and_result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            binary_num1 = 4'b0000;
            binary_num2 = 4'b0000;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (0000 & 0000)", test_num);
            reset_dut();
            binary_num1 = 4'b0000;
            binary_num2 = 4'b0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones (1111 & 1111)", test_num);
            reset_dut();
            binary_num1 = 4'b1111;
            binary_num2 = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complementary Bits (1010 & 0101)", test_num);
            reset_dut();
            binary_num1 = 4'b1010;
            binary_num2 = 4'b0101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Partial Overlap (1100 & 1010)", test_num);
            reset_dut();
            binary_num1 = 4'b1100;
            binary_num2 = 4'b1010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit Overlap (0001 & 1111)", test_num);
            reset_dut();
            binary_num1 = 4'b0001;
            binary_num2 = 4'b1111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Logic Check (0111 & 1011)", test_num);
            reset_dut();
            binary_num1 = 4'b0111;
            binary_num2 = 4'b1011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bitwise_and_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [3:0] expected_and_result;
        begin
            if (expected_and_result === (expected_and_result ^ and_result ^ expected_and_result)) begin
                $display("PASS");
                $display("  Outputs: and_result=%h",
                         and_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: and_result=%h",
                         expected_and_result);
                $display("  Got:      and_result=%h",
                         and_result);
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
        $dumpvars(0,binary_num1, binary_num2, clk, reset, and_result);
    end

endmodule
