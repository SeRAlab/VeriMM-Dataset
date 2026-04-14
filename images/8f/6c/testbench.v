`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_data;
    reg reset;
    reg wenb;
    wire [7:0] reg_0x44;

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
        .reg_0x44(reg_0x44)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
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
            test_num = test_num + 1;
            $display("Test %0d: Power-on Reset", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Write (0xAA)", test_num);
            reset_dut();
            @(negedge clk);
            wenb = 0;
            in_data = 8'hAA;
            @(negedge clk);
            wenb = 1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data Hold (wenb=1)", test_num);
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
            test_num = test_num + 1;
            $display("Test %0d: Sequential Overwrite (0x12 -> 0x34)", test_num);
            reset_dut();
            @(negedge clk);
            wenb = 0;
            in_data = 8'h12;
            @(negedge clk);
            in_data = 8'h34;
            @(negedge clk);
            wenb = 1;
            #1;

            check_outputs(8'h34);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Priority over Write", test_num);
            reset_dut();
            @(negedge clk);
            wenb = 0;
            in_data = 8'hFF;
            reset = 1;
            @(negedge clk);
            reset = 0;
            wenb = 1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bit Pattern (0x5A)", test_num);
            reset_dut();
            @(negedge clk);
            wenb = 0;
            in_data = 8'h5A;
            @(negedge clk);
            wenb = 1;
            #1;

            check_outputs(8'h5A);
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
        input [7:0] expected_reg_0x44;
        begin
            if (expected_reg_0x44 === (expected_reg_0x44 ^ reg_0x44 ^ expected_reg_0x44)) begin
                $display("PASS");
                $display("  Outputs: reg_0x44=%h",
                         reg_0x44);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_0x44=%h",
                         expected_reg_0x44);
                $display("  Got:      reg_0x44=%h",
                         reg_0x44);
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
        $dumpvars(0,clk, in_data, reset, wenb, reg_0x44);
    end

endmodule
