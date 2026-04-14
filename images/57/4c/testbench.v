`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] DATA;
    reg DECR;
    reg INCR;
    reg LD;
    reg RST;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DATA(DATA),
        .DECR(DECR),
        .INCR(INCR),
        .LD(LD),
        .RST(RST),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RST = 1;
        DATA = 0;
        DECR = 0;
        INCR = 0;
        LD = 0;
        wait_cycles(2);
        #1 RST = 0;
        wait_cycles(1);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Load and Read at Pointer 0", test_num);
        reset_dut();
        @(negedge CLK);
        LD = 1;
        DATA = 8'hA5;
        @(negedge CLK);
        LD = 0;
        #1 #1;
 check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Increment pointer and load at new position", test_num);
        reset_dut();
        @(negedge CLK);
        INCR = 1;
        @(negedge CLK);
        INCR = 0;
        LD = 1;
        DATA = 8'h5A;
        @(negedge CLK);
        LD = 0;
        #1 #1;
 check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Decrement pointer (wrap to 7) and load", test_num);
        reset_dut();
        @(negedge CLK);
        DECR = 1;
        @(negedge CLK);
        DECR = 0;
        LD = 1;
        DATA = 8'hEF;
        @(negedge CLK);
        LD = 0;
        #1 #1;
 check_outputs(8'hEF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify data persistence across pointer movements", test_num);
        reset_dut();
        @(negedge CLK);
        LD = 1; DATA = 8'h11;
        @(negedge CLK);
        LD = 0; INCR = 1;
        @(negedge CLK);
        LD = 1; DATA = 8'h22;
        @(negedge CLK);
        LD = 0; DECR = 1;
        @(negedge CLK);
        DECR = 0;
        #1 #1;
 check_outputs(8'h11);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary wrap-around (Increment 8 times back to 0)", test_num);
        reset_dut();
        @(negedge CLK);
        LD = 1; DATA = 8'hCC;
        @(negedge CLK);
        LD = 0; INCR = 1;
        wait_cycles(7);
        @(negedge CLK);
        INCR = 0;
        #1 #1;
 check_outputs(8'hCC);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Overwrite data at specific pointer", test_num);
        reset_dut();
        @(negedge CLK);
        LD = 1; DATA = 8'hAA;
        @(negedge CLK);
        DATA = 8'hBB;
        @(negedge CLK);
        LD = 0;
        #1 #1;
 check_outputs(8'hBB);
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
        input [7:0] expected_Q;
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
        $dumpvars(0,CLK, DATA, DECR, INCR, LD, RST, Q);
    end

endmodule
