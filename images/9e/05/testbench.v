`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg is_branch;
    reg [31:0] newPC;
    reg reset;
    wire [31:0] PC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .is_branch(is_branch),
        .newPC(newPC),
        .reset(reset),
        .PC(PC)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        is_branch = 0;
        newPC = 32'h0;
        @(posedge clk);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Power-on Reset Check", test_num);
        reset_dut();
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Sequential Increment Check", test_num);
        reset_dut();
        is_branch = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00000004);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Multiple Increments Check", test_num);
        reset_dut();
        is_branch = 0;
        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00000010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Branch Taken Check", test_num);
        reset_dut();
        is_branch = 1;
        newPC = 32'hA5A5C000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hA5A5C000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Branch followed by Increment", test_num);
        reset_dut();
        is_branch = 1;
        newPC = 32'h00001000;
        @(posedge clk);
        is_branch = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00001004);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset Priority Check", test_num);
        reset_dut();
        is_branch = 1;
        newPC = 32'hFFFFFFFF;
        reset = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00000000);
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
        input [31:0] expected_PC;
        begin
            if (expected_PC === (expected_PC ^ PC ^ expected_PC)) begin
                $display("PASS");
                $display("  Outputs: PC=%h",
                         PC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PC=%h",
                         expected_PC);
                $display("  Got:      PC=%h",
                         PC);
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
        $dumpvars(0,clk, is_branch, newPC, reset, PC);
    end

endmodule
