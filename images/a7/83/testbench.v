`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] cct_input;
    reg clear;
    reg clk;
    wire [7:0] cct_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cct_input(cct_input),
        .clear(clear),
        .clk(clk),
        .cct_output(cct_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clear = 1;
            cct_input = 8'h00;
            @(posedge clk);
            #1;
            clear = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking initial state after reset (8'b10000001)", test_num);
            reset_dut();

            #1;


            check_outputs(8'b10000001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking transition to second state (8'b01000010)", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b01000010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking transition to fourth state (8'b00011000)", test_num);
            reset_dut();



            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'b00011000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking wrap-around back to start state (8'b10000001)", test_num);
            reset_dut();

            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'b10000001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking reset functionality during active sequence", test_num);
            reset_dut();

            repeat(2) @(posedge clk);
            #1;


            clear = 1;
            @(posedge clk);
            #1;
            clear = 0;

            #1;


            check_outputs(8'b10000001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checking progression after two full cycles (8th edge)", test_num);
            reset_dut();

            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(8'b10000001);
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
        input [7:0] expected_cct_output;
        begin
            if (expected_cct_output === (expected_cct_output ^ cct_output ^ expected_cct_output)) begin
                $display("PASS");
                $display("  Outputs: cct_output=%h",
                         cct_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cct_output=%h",
                         expected_cct_output);
                $display("  Got:      cct_output=%h",
                         cct_output);
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
        $dumpvars(0,cct_input, clear, clk, cct_output);
    end

endmodule
