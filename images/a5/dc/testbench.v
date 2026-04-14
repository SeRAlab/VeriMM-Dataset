`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] i_state;
    reg reset;
    wire [2:0] o_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .i_state(i_state),
        .reset(reset),
        .o_state(o_state)
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
            i_state = 3'b000;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Checking initial reset...", test_num);
            reset_dut();
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Writing 3'b101...", test_num);
            reset_dut();
            i_state = 3'b101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Writing 3'b011...", test_num);
            reset_dut();
            i_state = 3'b011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset override during input...", test_num);
            reset_dut();
            i_state = 3'b111;
            @(negedge clk);
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Consecutive updates (110 -> 001)...", test_num);
            reset_dut();
            i_state = 3'b110;
            @(posedge clk);
            #1;
            i_state = 3'b001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b001);
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
        input [2:0] expected_o_state;
        begin
            if (expected_o_state === (expected_o_state ^ o_state ^ expected_o_state)) begin
                $display("PASS");
                $display("  Outputs: o_state=%h",
                         o_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_state=%h",
                         expected_o_state);
                $display("  Got:      o_state=%h",
                         o_state);
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
        $dumpvars(0,clk, i_state, reset, o_state);
    end

endmodule
