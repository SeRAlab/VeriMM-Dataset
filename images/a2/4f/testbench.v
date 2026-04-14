`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] D;
    reg [3:0] DATA;
    reg LOAD;
    reg RESET;
    reg SHIFT;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D(D),
        .DATA(DATA),
        .LOAD(LOAD),
        .RESET(RESET),
        .SHIFT(SHIFT),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RESET = 1;
        LOAD = 0;
        SHIFT = 0;
        DATA = 0;
        D = 0;
        @(negedge CLK);
        RESET = 0;
        @(negedge CLK);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verifying Reset and Basic Incrementing...", test_num);
        reset_dut();

        repeat(5) @(negedge CLK);
        @(posedge CLK); #1;
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verifying LOAD functionality...", test_num);
        reset_dut();
        DATA = 4'hA;
        LOAD = 1;
        @(negedge CLK);
        LOAD = 0;
        @(posedge CLK); #1;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verifying incrementing after LOAD...", test_num);
        reset_dut();
        DATA = 4'h7;
        LOAD = 1;
        @(negedge CLK);
        LOAD = 0;
        repeat(3) @(negedge CLK);
        @(posedge CLK); #1;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verifying counter rollover (15 to 0)...", test_num);
        reset_dut();
        DATA = 4'hF;
        LOAD = 1;
        @(negedge CLK);
        LOAD = 0;
        @(negedge CLK);
        @(posedge CLK); #1;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Verifying counter increments while SHIFT is active...", test_num);
        reset_dut();
        SHIFT = 1;
        repeat(4) @(negedge CLK);
        SHIFT = 0;
        @(posedge CLK); #1;
        #1;

        check_outputs(4'h4);
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
        $dumpvars(0,CLK, D, DATA, LOAD, RESET, SHIFT, Q);
    end

endmodule
