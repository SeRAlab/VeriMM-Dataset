`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_data;
    reg reset;
    reg wenb;
    wire [7:0] reg_0x1D;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in_data(in_data),
        .reset(reset),
        .wenb(wenb),
        .reg_0x1D(reg_0x1D)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            wenb = 0;
            in_data = 8'h00;
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
            $display("Test Case 001: Reset Functional Test");
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Basic Write (0xA5)");
            reset_dut();
            in_data = 8'hA5;
            wenb = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Write Disable Check (wenb=0)");
            reset_dut();

            in_data = 8'h55;
            wenb = 1;
            @(posedge clk);
            #1;

            in_data = 8'hAA;
            wenb = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Sequential Write Check");
            reset_dut();
            wenb = 1;
            in_data = 8'h11;
            @(posedge clk);
            #1;
            in_data = 8'h22;
            @(posedge clk);
            #1;
            in_data = 8'h33;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Data Retention Check");
            reset_dut();

            in_data = 8'hBC;
            wenb = 1;
            @(posedge clk);
            #1;

            wenb = 0;
            in_data = 8'h00;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hBC);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Reset Priority Check");
            reset_dut();

            in_data = 8'hFF;
            wenb = 1;
            @(posedge clk);
            #1;

            reset = 1;
            in_data = 8'hEE;
            wenb = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: All Bits High (0xFF)");
            reset_dut();
            in_data = 8'hFF;
            wenb = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
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
        input [7:0] expected_reg_0x1D;
        begin
            if (expected_reg_0x1D === (expected_reg_0x1D ^ reg_0x1D ^ expected_reg_0x1D)) begin
                $display("PASS");
                $display("  Outputs: reg_0x1D=%h",
                         reg_0x1D);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_0x1D=%h",
                         expected_reg_0x1D);
                $display("  Got:      reg_0x1D=%h",
                         reg_0x1D);
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
        $dumpvars(0,clk, in_data, reset, wenb, reg_0x1D);
    end

endmodule
