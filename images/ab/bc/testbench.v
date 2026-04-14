`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire alu_ena;
    wire fetch;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .alu_ena(alu_ena),
        .fetch(fetch)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Checking outputs in IDLE state", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk); #2;
            $display("Testcase %0d: Checking outputs in S1 (alu_ena active)", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            repeat(2) @(posedge clk); #2;
            $display("Testcase %0d: Checking outputs in S2 (alu_ena inactive)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            repeat(3) @(posedge clk); #2;
            $display("Testcase %0d: Checking outputs in S3 (fetch active)", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            repeat(5) @(posedge clk); #2;
            $display("Testcase %0d: Checking outputs in S5 (fetch remains active)", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            repeat(6) @(posedge clk); #2;
            $display("Testcase %0d: Checking outputs in S6 (fetch remains active)", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            repeat(7) @(posedge clk); #2;
            $display("Testcase %0d: Checking outputs in S7 (fetch reset)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            repeat(8) @(posedge clk); #2;
            $display("Testcase %0d: Checking outputs in S8", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_alu_ena;
        input expected_fetch;
        begin
            if (expected_alu_ena === (expected_alu_ena ^ alu_ena ^ expected_alu_ena) &&
                expected_fetch === (expected_fetch ^ fetch ^ expected_fetch)) begin
                $display("PASS");
                $display("  Outputs: alu_ena=%b, fetch=%b",
                         alu_ena, fetch);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_ena=%b, fetch=%b",
                         expected_alu_ena, expected_fetch);
                $display("  Got:      alu_ena=%b, fetch=%b",
                         alu_ena, fetch);
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
        $dumpvars(0,clk, reset, alu_ena, fetch);
    end

endmodule
