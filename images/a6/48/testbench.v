`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg reset_n;
    wire digit;
    wire [2:0] sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .reset_n(reset_n),
        .digit(digit),
        .sel(sel)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            reset_n = 1'b0;
            @(negedge clk_i);
            reset_n = 1'b1;
            @(negedge clk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reset behavior (S0)", test_num);
            reset_dut();


            #1;



            check_outputs(1'b1, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Transition to S1", test_num);
            reset_dut();

            @(posedge clk_i);
            #1;

            #1;


            check_outputs(1'b1, 3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Transition to S2", test_num);
            reset_dut();

            repeat(2) @(posedge clk_i);
            #1;

            #1;


            check_outputs(1'b0, 3'b011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Transition to S3", test_num);
            reset_dut();

            repeat(3) @(posedge clk_i);
            #1;

            #1;


            check_outputs(1'b1, 3'b100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Wrap around S3 -> S0", test_num);
            reset_dut();

            repeat(4) @(posedge clk_i);
            #1;

            #1;


            check_outputs(1'b1, 3'b000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Extended cycle (7 steps)", test_num);
            reset_dut();

            repeat(7) @(posedge clk_i);
            #1;

            #1;


            check_outputs(1'b1, 3'b100);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Mid-cycle reset", test_num);
            reset_dut();
            repeat(2) @(posedge clk_i);
            #1;

            @(negedge clk_i);
            reset_n = 1'b0;
            @(negedge clk_i);
            reset_n = 1'b1;
            #1;

            #1;


            check_outputs(1'b1, 3'b000);
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
        input expected_digit;
        input [2:0] expected_sel;
        begin
            if (expected_digit === (expected_digit ^ digit ^ expected_digit) &&
                expected_sel === (expected_sel ^ sel ^ expected_sel)) begin
                $display("PASS");
                $display("  Outputs: digit=%b, sel=%h",
                         digit, sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digit=%b, sel=%h",
                         expected_digit, expected_sel);
                $display("  Got:      digit=%b, sel=%h",
                         digit, sel);
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
        $dumpvars(0,clk_i, reset_n, digit, sel);
    end

endmodule
