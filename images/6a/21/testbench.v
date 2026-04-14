`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk_ena;
    reg [3:0] dfload;
    reg load;
    reg rst;
    wire carry;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk_ena(clk_ena),
        .dfload(dfload),
        .load(load),
        .rst(rst),
        .carry(carry)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            clk_ena = 0;
            load = 0;
            dfload = 4'b0000;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset and check carry", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load non-zero value and check carry", test_num);
            reset_dut();
            load = 1;
            dfload = 4'b1010;
            @(posedge clk);
            #1;
            load = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Count down from 3 to 0", test_num);
            reset_dut();
            load = 1;
            dfload = 4'b0011;
            @(posedge clk);
            #1;
            load = 0;
            clk_ena = 1;

            repeat (3) begin
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Counter should not change when clk_ena is low", test_num);
            reset_dut();
            load = 1;
            dfload = 4'b0001;
            @(posedge clk);
            #1;
            load = 0;
            clk_ena = 0;
            repeat (5) begin
                @(posedge clk);
                #1;
            end

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Check wrap around from 0 to 15", test_num);
            reset_dut();
            clk_ena = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load 0 and check carry", test_num);
            reset_dut();
            load = 1;
            dfload = 4'b0000;
            @(posedge clk);
            #1;
            load = 0;

            #1;


            check_outputs(1'b1);
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
        input expected_carry;
        begin
            if (expected_carry === (expected_carry ^ carry ^ expected_carry)) begin
                $display("PASS");
                $display("  Outputs: carry=%b",
                         carry);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b",
                         expected_carry);
                $display("  Got:      carry=%b",
                         carry);
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
        $dumpvars(0,clk, clk_ena, dfload, load, rst, carry);
    end

endmodule
