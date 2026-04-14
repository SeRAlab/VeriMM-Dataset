`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg frame_i;
    reg sys_clk_i;
    reg sys_reset_i;
    wire ptr_inc_o;
    wire reset_o;
    wire we_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .frame_i(frame_i),
        .sys_clk_i(sys_clk_i),
        .sys_reset_i(sys_reset_i),
        .ptr_inc_o(ptr_inc_o),
        .reset_o(reset_o),
        .we_o(we_o)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk_i = 0;
        forever #5 sys_clk_i = ~sys_clk_i;
    end

        task reset_dut;

    begin
        sys_reset_i = 1;
        frame_i = 0;
        repeat(2) @(posedge sys_clk_i);
        #1 sys_reset_i = 0;
        repeat(1) @(posedge sys_clk_i);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Reset and Idle");
        reset_dut();


        @(posedge sys_clk_i);
        #1;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Rising Edge we_o");
        reset_dut();
        @(posedge sys_clk_i);
        frame_i = 1;
        @(posedge sys_clk_i);
        #1;

        #1;


        check_outputs(1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Sustained Frame");
        reset_dut();
        @(posedge sys_clk_i);
        frame_i = 1;
        repeat(3) @(posedge sys_clk_i);
        #1;


        #1;



        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Frame De-assertion");
        reset_dut();
        @(posedge sys_clk_i);
        frame_i = 1;
        @(posedge sys_clk_i);
        frame_i = 0;
        repeat(2) @(posedge sys_clk_i);
        #1;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Multiple Pulses");
        reset_dut();

        @(posedge sys_clk_i);
        frame_i = 1;
        @(posedge sys_clk_i);
        frame_i = 0;

        repeat(2) @(posedge sys_clk_i);

        frame_i = 1;
        @(posedge sys_clk_i);
        #1;
        #1;

        check_outputs(1'b1, 1'b0, 1'b1);
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
        input expected_ptr_inc_o;
        input expected_reset_o;
        input expected_we_o;
        begin
            if (expected_ptr_inc_o === (expected_ptr_inc_o ^ ptr_inc_o ^ expected_ptr_inc_o) &&
                expected_reset_o === (expected_reset_o ^ reset_o ^ expected_reset_o) &&
                expected_we_o === (expected_we_o ^ we_o ^ expected_we_o)) begin
                $display("PASS");
                $display("  Outputs: ptr_inc_o=%b, reset_o=%b, we_o=%b",
                         ptr_inc_o, reset_o, we_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ptr_inc_o=%b, reset_o=%b, we_o=%b",
                         expected_ptr_inc_o, expected_reset_o, expected_we_o);
                $display("  Got:      ptr_inc_o=%b, reset_o=%b, we_o=%b",
                         ptr_inc_o, reset_o, we_o);
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
        $dumpvars(0,frame_i, sys_clk_i, sys_reset_i, ptr_inc_o, reset_o, we_o);
    end

endmodule
