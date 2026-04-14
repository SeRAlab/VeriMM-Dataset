`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control;
    reg [7:0] data_in;
    reg enable;
    reg reset;
    reg select;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .control(control),
        .data_in(data_in),
        .enable(enable),
        .reset(reset),
        .select(select),
        .q(q)
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
            control = 0;
            select = 0;
            data_in = 8'h00;
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            select = 0;
            control = 0;
            #2;
            $display("Testcase 001: Reset Check");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            select = 1;
            data_in = 8'hA5;
            control = 0;
            #2;
            $display("Testcase 002: External Data Selection");
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            select = 0;
            control = 1;
            #2;
            $display("Testcase 003: Constant 8'hFF Selection");
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            select = 0;
            control = 0;
            enable = 1;

            repeat(5) @(posedge clk);
            #2;
            $display("Testcase 004: Counter Increment (5 cycles)");
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            select = 0;
            control = 0;
            enable = 1;
            repeat(2) @(posedge clk);
            enable = 0;
            repeat(3) @(posedge clk);
            #2;
            $display("Testcase 005: Counter Enable Disable");
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            select = 0;
            control = 0;
            enable = 1;
            repeat(17) @(posedge clk);
            #2;
            $display("Testcase 006: Counter Rollover");
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            data_in = 8'h33;
            select = 1;
            control = 1;
            #2;
            $display("Testcase 007: Priority Select vs Control");
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            enable = 1;
            repeat(3) @(posedge clk);
            control = 1;
            repeat(2) @(posedge clk);
            select = 1;
            data_in = 8'hBC;
            #2;
            $display("Testcase 008: Dynamic Signal Switching");
            #1;

            check_outputs(8'hBC);
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
        input [7:0] expected_q;
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
        $dumpvars(0,clk, control, data_in, enable, reset, select, q);
    end

endmodule
