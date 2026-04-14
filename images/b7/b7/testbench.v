`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg CLK;
    reg DOWN;
    reg RST;
    reg UP;
    wire [2:0] Q;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .CLK(CLK),
        .DOWN(DOWN),
        .RST(RST),
        .UP(UP),
        .Q(Q),
        .Y(Y)
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
        A = 0;
        @(posedge CLK);
        #1 RST = 0;
        @(posedge CLK);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset State", test_num);
        reset_dut();
        A = 4'd5;
        @(posedge CLK);
        #1;

        check_outputs(3'd0, 8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Increment Counter", test_num);
        reset_dut();
        A = 4'd3;
        UP = 1;
        repeat(2) @(posedge CLK);
        UP = 0;
        #1;
        #1;

        check_outputs(3'd2, 8'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Decrement Counter (Underflow)", test_num);
        reset_dut();
        A = 4'd4;
        DOWN = 1;
        repeat(2) @(posedge CLK);
        DOWN = 0;
        #1;
        #1;

        check_outputs(3'd6, 8'd30);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Values", test_num);
        reset_dut();
        A = 4'd15;
        UP = 1;
        repeat(7) @(posedge CLK);
        UP = 0;
        #1;
        #1;

        check_outputs(3'd7, 8'd112);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Up/Down Stability", test_num);
        reset_dut();
        A = 4'd10;
        UP = 1;
        repeat(3) @(posedge CLK);
        DOWN = 1;
        repeat(2) @(posedge CLK);
        UP = 0;
        DOWN = 0;
        #1;



        #1;




        check_outputs(Q, (10 * Q) + Q);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiply by Zero A", test_num);
        reset_dut();
        A = 4'd0;
        UP = 1;
        repeat(4) @(posedge CLK);
        UP = 0;
        #1;
        #1;

        check_outputs(3'd4, 8'd4);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large A Small Q", test_num);
        reset_dut();
        A = 4'd12;
        UP = 1;
        @(posedge CLK);
        UP = 0;
        #1;
        #1;

        check_outputs(3'd1, 8'd13);
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
        input [2:0] expected_Q;
        input [7:0] expected_Y;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, Y=%h",
                         Q, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, Y=%h",
                         expected_Q, expected_Y);
                $display("  Got:      Q=%h, Y=%h",
                         Q, Y);
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
        $dumpvars(0,A, CLK, DOWN, RST, UP, Q, Y);
    end

endmodule
