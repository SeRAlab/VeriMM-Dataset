`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [19:0] load_value;
    reg shift_left;
    reg shift_right;
    wire [19:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .load_value(load_value),
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
            load = 1;
            load_value = 20'h0;
            shift_left = 0;
            shift_right = 0;
            @(posedge clk);
            #1;
            load = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Parallel Load");
            reset_dut();
            load = 1;
            load_value = 20'hA5A5A;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(20'hA5A5A);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Shift Left once");
            reset_dut();

            load = 1;
            load_value = 20'h00001;
            @(posedge clk);
            #1;
            load = 0;

            shift_left = 1;
            @(posedge clk);
            #1;
            shift_left = 0;
            #1;

            check_outputs(20'h00002);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Shift Right once");
            reset_dut();

            load = 1;
            load_value = 20'h00002;
            @(posedge clk);
            #1;
            load = 0;

            shift_right = 1;
            @(posedge clk);
            #1;
            shift_right = 0;
            #1;

            check_outputs(20'h00001);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Shift Left 4 times");
            reset_dut();
            load = 1;
            load_value = 20'h0000F;
            @(posedge clk);
            #1;
            load = 0;
            shift_left = 1;
            repeat(4) @(posedge clk);
            #1;
            shift_left = 0;
            #1;

            check_outputs(20'h000F0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Shift Right 4 times");
            reset_dut();
            load = 1;
            load_value = 20'hF0000;
            @(posedge clk);
            #1;
            load = 0;
            shift_right = 1;
            repeat(4) @(posedge clk);
            #1;
            shift_right = 0;
            #1;

            check_outputs(20'h0F000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Shift Left into MSB and out");
            reset_dut();
            load = 1;
            load_value = 20'h80000;
            @(posedge clk);
            #1;
            load = 0;
            shift_left = 1;
            @(posedge clk);
            #1;
            shift_left = 0;
            #1;

            check_outputs(20'h00000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Shift Right into LSB and out");
            reset_dut();
            load = 1;
            load_value = 20'h00001;
            @(posedge clk);
            #1;
            load = 0;
            shift_right = 1;
            @(posedge clk);
            #1;
            shift_right = 0;
            #1;

            check_outputs(20'h00000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Load priority over Shift");
            reset_dut();
            load = 1;
            load_value = 20'h55555;
            shift_left = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift_left = 0;
            #1;

            check_outputs(20'h55555);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: No control signals (Hold value)");
            reset_dut();
            load = 1;
            load_value = 20'hABCDE;
            @(posedge clk);
            #1;
            load = 0;
            shift_left = 0;
            shift_right = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(20'hABCDE);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Shift Right All 1s");
            reset_dut();
            load = 1;
            load_value = 20'hFFFFF;
            @(posedge clk);
            #1;
            load = 0;
            shift_right = 1;
            @(posedge clk);
            #1;
            shift_right = 0;
            #1;

            check_outputs(20'h7FFFF);
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
        input [19:0] expected_q;
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
        $dumpvars(0,clk, load, load_value, shift_left, shift_right, q);
    end

endmodule
