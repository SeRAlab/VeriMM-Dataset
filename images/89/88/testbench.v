`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg reset;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .reset(reset),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 1;
        @(posedge clock);
        #1;
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Testing initial reset state (Q=1111)", test_num);
        reset_dut();
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Testing after 1 clock cycle", test_num);
        reset_dut();
        @(posedge clock);
        #1;

        #1;


        check_outputs(4'h7);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Testing after 3 clock cycles", test_num);
        reset_dut();
        repeat(3) @(posedge clock);
        #1;

        #1;


        check_outputs(4'h5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Testing after 7 clock cycles", test_num);
        reset_dut();
        repeat(7) @(posedge clock);
        #1;

        #1;


        check_outputs(4'h3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Testing after 11 clock cycles", test_num);
        reset_dut();
        repeat(11) @(posedge clock);
        #1;

        #1;


        check_outputs(4'h1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Testing full loop (15 cycles) to return to 1111", test_num);
        reset_dut();
        repeat(15) @(posedge clock);
        #1;

        #1;


        check_outputs(4'hf);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Testing mid-sequence reset", test_num);
        reset_dut();
        repeat(5) @(posedge clock);
        #1;

        reset_dut();
        #1;

        check_outputs(4'hf);
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,clock, reset, Q);
    end

endmodule
