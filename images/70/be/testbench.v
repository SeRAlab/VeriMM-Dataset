`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_data;
    reg reset;
    reg wenb;
    wire [7:0] reg_0x1A;

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
        .reg_0x1A(reg_0x1A)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            wenb = 1;
            in_data = 8'h00;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Check...");
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Basic Write...");
            reset_dut();
            @(negedge clk);
            wenb = 0;
            in_data = 8'hA5;
            @(negedge clk);
            wenb = 1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Write Disable Check...");
            reset_dut();
            @(negedge clk);
            wenb = 0;
            in_data = 8'h55;
            @(negedge clk);
            wenb = 1;
            in_data = 8'hFF;
            @(negedge clk);

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Consecutive Writes...");
            reset_dut();
            @(negedge clk);
            wenb = 0; in_data = 8'h11;
            @(negedge clk);
            wenb = 0; in_data = 8'h22;
            @(negedge clk);
            wenb = 0; in_data = 8'h33;
            @(negedge clk);
            wenb = 1;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset Priority Check...");
            reset_dut();
            @(negedge clk);
            wenb = 0;
            in_data = 8'hAA;
            reset = 1;
            @(negedge clk);
            reset = 0;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_reg_0x1A;
        begin
            if (expected_reg_0x1A === (expected_reg_0x1A ^ reg_0x1A ^ expected_reg_0x1A)) begin
                $display("PASS");
                $display("  Outputs: reg_0x1A=%h",
                         reg_0x1A);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_0x1A=%h",
                         expected_reg_0x1A);
                $display("  Got:      reg_0x1A=%h",
                         reg_0x1A);
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
        $dumpvars(0,clk, in_data, reset, wenb, reg_0x1A);
    end

endmodule
