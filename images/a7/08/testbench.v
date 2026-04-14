`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    wire [7:0] current_random;
    wire [15:0] current_sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .current_random(current_random),
        .current_sum(current_sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State Check", test_num);
            reset_dut();


            #1;



            check_outputs(current_random, 16'h0000);
        end
        endtask

    task testcase002;

        reg [15:0] expected_sum;
        begin
            test_num = 2;
            $display("Testcase %03d: Single Accumulation Cycle", test_num);
            reset_dut();

            enable = 1;
            @(posedge clk);
            #1;

            expected_sum = current_random;
            enable = 0;

            #1;


            check_outputs(current_random, expected_sum);
        end
        endtask

    task testcase003;

        reg [15:0] expected_sum;
        integer i;
        begin
            test_num = 3;
            $display("Testcase %03d: Multiple Accumulation Cycles", test_num);
            reset_dut();

            expected_sum = 0;
            enable = 1;

            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
                #1;
                expected_sum = expected_sum + current_random;
            end
            enable = 0;

            #1;


            check_outputs(current_random, expected_sum);
        end
        endtask

    task testcase004;

        reg [7:0] captured_random;
        reg [15:0] captured_sum;
        begin
            test_num = 4;
            $display("Testcase %03d: Enable Signal Gating Check", test_num);
            reset_dut();


            enable = 1;
            @(posedge clk);
            #1;
            captured_random = current_random;
            captured_sum = current_sum;


            enable = 0;
            repeat (3) @(posedge clk);
            #1;


            #1;



            check_outputs(captured_random, captured_sum);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Reset Mid-Operation", test_num);
            reset_dut();

            enable = 1;
            repeat (3) @(posedge clk);


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;


            #1;



            check_outputs(current_random, 16'h0000);
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
        input [7:0] expected_current_random;
        input [15:0] expected_current_sum;
        begin
            if (expected_current_random === (expected_current_random ^ current_random ^ expected_current_random) &&
                expected_current_sum === (expected_current_sum ^ current_sum ^ expected_current_sum)) begin
                $display("PASS");
                $display("  Outputs: current_random=%h, current_sum=%h",
                         current_random, current_sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_random=%h, current_sum=%h",
                         expected_current_random, expected_current_sum);
                $display("  Got:      current_random=%h, current_sum=%h",
                         current_random, current_sum);
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
        $dumpvars(0,clk, enable, reset, current_random, current_sum);
    end

endmodule
