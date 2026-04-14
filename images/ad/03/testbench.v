`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] reg_in;
    reg reset;
    wire [31:0] reg_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reg_in(reg_in),
        .reset(reset),
        .reg_out(reg_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            reg_in = 16'h0;
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive Value (MSB=0)", test_num);
            reset_dut();
            reg_in = 16'h0005;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000005);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative Value (MSB=1)", test_num);
            reset_dut();
            reg_in = 16'h8005;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFF8005);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero", test_num);
            reset_dut();
            reg_in = 16'h0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Positive (7FFF)", test_num);
            reset_dut();
            reg_in = 16'h7FFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00007FFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Min Negative (8000)", test_num);
            reset_dut();
            reg_in = 16'h8000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFF8000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones (FFFF)", test_num);
            reset_dut();
            reg_in = 16'hFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern 1234", test_num);
            reset_dut();
            reg_in = 16'h1234;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00001234);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern ABCD", test_num);
            reset_dut();
            reg_in = 16'hABCD;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFABCD);
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
        input [31:0] expected_reg_out;
        begin
            if (expected_reg_out === (expected_reg_out ^ reg_out ^ expected_reg_out)) begin
                $display("PASS");
                $display("  Outputs: reg_out=%h",
                         reg_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_out=%h",
                         expected_reg_out);
                $display("  Got:      reg_out=%h",
                         reg_out);
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
        $dumpvars(0,clk, reg_in, reset, reg_out);
    end

endmodule
