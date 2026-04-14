`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] B;
    reg CLK;
    reg DOWN;
    reg RST;
    reg SHIFT;
    reg UP;
    wire [3:0] Q;
    wire [3:0] RESULT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B(B),
        .CLK(CLK),
        .DOWN(DOWN),
        .RST(RST),
        .SHIFT(SHIFT),
        .UP(UP),
        .Q(Q),
        .RESULT(RESULT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RST = 1;
        UP = 0;
        DOWN = 0;
        SHIFT = 0;
        B = 0;
        @(posedge CLK);
        #1;
        RST = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset State Verification", test_num);
        reset_dut();
        @(posedge CLK);
        #1;
        #1;

        check_outputs(4'h0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Counting Up to 5", test_num);
        reset_dut();
        UP = 1;
        DOWN = 0;
        repeat(5) @(posedge CLK);
        #1;
        #1;

        check_outputs(4'h5, 4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Counting Down (Wrap to 15)", test_num);
        reset_dut();
        UP = 0;
        DOWN = 1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(4'hf, 4'hf);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift Left by 1 (Q=3 -> RESULT=6)", test_num);
        reset_dut();
        UP = 1;
        repeat(3) @(posedge CLK);
        UP = 0;
        SHIFT = 1;
        B = 4'h1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(4'h3, 4'h6);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift Left by 2 (Q=2 -> RESULT=8)", test_num);
        reset_dut();
        UP = 1;
        repeat(2) @(posedge CLK);
        UP = 0;
        SHIFT = 1;
        B = 4'h2;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(4'h2, 4'h8);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Hold value when UP and DOWN are both active/inactive", test_num);
        reset_dut();
        UP = 1;
        repeat(4) @(posedge CLK);
        UP = 1; DOWN = 1;
        repeat(2) @(posedge CLK);
        #1;
        #1;

        check_outputs(4'h4, 4'h4);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Upward Wrap-around (15 to 0)", test_num);
        reset_dut();
        UP = 1;
        repeat(16) @(posedge CLK);
        #1;
        #1;

        check_outputs(4'h0, 4'h0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift by 0 positions", test_num);
        reset_dut();
        UP = 1;
        repeat(7) @(posedge CLK);
        UP = 0;
        SHIFT = 1;
        B = 4'h0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(4'h7, 4'h7);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift Result Overflow (Q=8, B=1 -> RESULT=0)", test_num);
        reset_dut();
        UP = 1;
        repeat(8) @(posedge CLK);
        UP = 0;
        SHIFT = 1;
        B = 4'h1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(4'h8, 4'h0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Count Down and Shift Simultaneously", test_num);
        reset_dut();
        UP = 1;
        repeat(10) @(posedge CLK);
        UP = 0;
        DOWN = 1;
        SHIFT = 1;
        B = 4'h1;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(4'h9, 4'h2);
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
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_RESULT;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_RESULT === (expected_RESULT ^ RESULT ^ expected_RESULT)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, RESULT=%h",
                         Q, RESULT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, RESULT=%h",
                         expected_Q, expected_RESULT);
                $display("  Got:      Q=%h, RESULT=%h",
                         Q, RESULT);
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
        $dumpvars(0,B, CLK, DOWN, RST, SHIFT, UP, Q, RESULT);
    end

endmodule
