`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [5:0] x_os;
    reg [5:0] y_os;
    wire [11:0] x_os_integ;
    wire [11:0] y_os_integ;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .x_os(x_os),
        .y_os(y_os),
        .x_os_integ(x_os_integ),
        .y_os_integ(y_os_integ)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            x_os = 0;
            y_os = 0;

            repeat(3) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Positive Accumulation", test_num);
            reset_dut();

            @(negedge clk); x_os = 6'd1;  y_os = 6'd10;
            @(negedge clk); x_os = 6'd2;  y_os = 6'd20;
            @(negedge clk); x_os = 6'd3;  y_os = 6'd30;

            @(posedge clk);
            #2;
            #1;

            check_outputs(12'd6, 12'd60);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Negative Values (Sign Extension)", test_num);
            reset_dut();



            @(negedge clk); x_os = -6'sd1; y_os = -6'sd5;
            @(negedge clk); x_os = -6'sd2; y_os = -6'sd10;
            @(negedge clk); x_os = -6'sd3; y_os = -6'sd15;

            @(posedge clk);
            #2;
            #1;

            check_outputs(12'hFFA, 12'hFE2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mixed Values Resulting in Zero", test_num);
            reset_dut();

            @(negedge clk); x_os = 6'sd31;  y_os = -6'sd32;
            @(negedge clk); x_os = -6'sd31; y_os = 6'sd31;
            @(negedge clk); x_os = 0;       y_os = 6'sd1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(12'h000, 12'h000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Maximum Positive Inputs", test_num);
            reset_dut();


            @(negedge clk); x_os = 6'sd31; y_os = 6'sd31;
            @(negedge clk); x_os = 6'sd31; y_os = 6'sd31;
            @(negedge clk); x_os = 6'sd31; y_os = 6'sd31;

            @(posedge clk);
            #2;
            #1;

            check_outputs(12'h05D, 12'h05D);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Maximum Negative Inputs", test_num);
            reset_dut();


            @(negedge clk); x_os = -6'sd32; y_os = -6'sd32;
            @(negedge clk); x_os = -6'sd32; y_os = -6'sd32;
            @(negedge clk); x_os = -6'sd32; y_os = -6'sd32;

            @(posedge clk);
            #2;
            #1;

            check_outputs(12'hFA0, 12'hFA0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Asymmetric Inputs", test_num);
            reset_dut();

            @(negedge clk); x_os = 6'sd15;  y_os = -6'sd10;
            @(negedge clk); x_os = -6'sd5;   y_os = 6'sd20;
            @(negedge clk); x_os = 6'sd2;   y_os = -6'sd5;

            @(posedge clk);
            #2;
            #1;

            check_outputs(12'sd12, 12'sd5);
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
        input [11:0] expected_x_os_integ;
        input [11:0] expected_y_os_integ;
        begin
            if (expected_x_os_integ === (expected_x_os_integ ^ x_os_integ ^ expected_x_os_integ) &&
                expected_y_os_integ === (expected_y_os_integ ^ y_os_integ ^ expected_y_os_integ)) begin
                $display("PASS");
                $display("  Outputs: x_os_integ=%h, y_os_integ=%h",
                         x_os_integ, y_os_integ);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_os_integ=%h, y_os_integ=%h",
                         expected_x_os_integ, expected_y_os_integ);
                $display("  Got:      x_os_integ=%h, y_os_integ=%h",
                         x_os_integ, y_os_integ);
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
        $dumpvars(0,clk, x_os, y_os, x_os_integ, y_os_integ);
    end

endmodule
