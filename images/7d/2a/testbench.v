`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] sig;
    wire [7:0] thing;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .sig(sig),
        .thing(thing)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        sig = 4'b1111;
        force dut.thing = 8'h00;
        #1;
        release dut.thing;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Testing sig=0000 (Bit 0 set)", test_num);
        reset_dut();
        sig = 4'b0000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Testing sig=0010 (Bit 2 set)", test_num);
        reset_dut();
        sig = 4'b0010;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h04);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Testing sig=0011 (Out-of-bounds 9th bit)", test_num);
        reset_dut();
        sig = 4'b0011;
        @(posedge clk);
        #2;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Testing undefined sig=0100 (No change)", test_num);
        reset_dut();
        sig = 4'b0100;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Testing persistence (sig=0000 then sig=0111)", test_num);
        reset_dut();

        sig = 4'b0000;
        @(posedge clk);
        #2;

        sig = 4'b0111;
        @(posedge clk);
        #2;
        #1;

        check_outputs(8'h01);
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
        input [7:0] expected_thing;
        begin
            if (expected_thing === (expected_thing ^ thing ^ expected_thing)) begin
                $display("PASS");
                $display("  Outputs: thing=%h",
                         thing);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: thing=%h",
                         expected_thing);
                $display("  Got:      thing=%h",
                         thing);
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
        $dumpvars(0,clk, sig, thing);
    end

endmodule
