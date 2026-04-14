`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data;
    reg load;
    reg reset;
    reg shift_left;
    reg shift_right;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .load(load),
        .reset(reset),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            #1;
            reset = 1;
            load = 0;
            shift_left = 0;
            shift_right = 0;
            data = 4'b0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Verification");
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Load Data");
            reset_dut();
            @(posedge clk);
            #1;
            load = 1;
            data = 4'b1011;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Shift Left");
            reset_dut();

            @(posedge clk);
            #1;
            load = 1;
            data = 4'b0101;
            @(posedge clk);
            #1;
            load = 0;
            shift_left = 1;
            @(posedge clk);
            #1;
            shift_left = 0;

            #1;


            check_outputs(4'b1010);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Shift Right");
            reset_dut();

            @(posedge clk);
            #1;
            load = 1;
            data = 4'b1010;
            @(posedge clk);
            #1;
            load = 0;
            shift_right = 1;
            @(posedge clk);
            #1;
            shift_right = 0;

            #1;


            check_outputs(4'b0101);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Hold Value");
            reset_dut();

            @(posedge clk);
            #1;
            load = 1;
            data = 4'b1111;
            @(posedge clk);
            #1;
            load = 0;
            shift_left = 0;
            shift_right = 0;

            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Multiple Shift Lefts");
            reset_dut();
            @(posedge clk);
            #1;
            load = 1;
            data = 4'b1000;
            @(posedge clk);
            #1;
            load = 0;
            shift_left = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            shift_left = 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Multiple Shift Rights");
            reset_dut();
            @(posedge clk);
            #1;
            load = 1;
            data = 4'b0001;
            @(posedge clk);
            #1;
            load = 0;
            shift_right = 1;
            @(posedge clk);
            #1;
            shift_right = 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Priority check (Load over Shift)");
            reset_dut();
            @(posedge clk);
            #1;
            load = 1;
            data = 4'b1111;
            shift_left = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift_left = 0;


            #1;



            check_outputs(4'b1111);
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
        input [3:0] expected_q;
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
        $dumpvars(0,clk, data, load, reset, shift_left, shift_right, q);
    end

endmodule
