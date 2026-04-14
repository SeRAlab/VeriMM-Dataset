`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [17:0] A;
    reg [17:0] B;
    reg CLK;
    reg RST;
    wire [35:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CLK(CLK),
        .RST(RST),
        .Z(Z)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RST = 1;
        A = 0;
        B = 0;
        @(posedge CLK);
        #1;
        RST = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        A = 18'sd10;
        B = 18'sd25;
        @(posedge CLK);
        #1;
        $display("Test %0d: Positive x Positive (10 * 25)", test_num);
        #1;

        check_outputs(36'sd250);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        A = 18'sd15;
        B = -18'sd30;
        @(posedge CLK);
        #1;
        $display("Test %0d: Positive x Negative (15 * -30)", test_num);
        #1;

        check_outputs(-36'sd450);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        A = -18'sd50;
        B = 18'sd4;
        @(posedge CLK);
        #1;
        $display("Test %0d: Negative x Positive (-50 * 4)", test_num);
        #1;

        check_outputs(-36'sd200);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        A = -18'sd12;
        B = -18'sd12;
        @(posedge CLK);
        #1;
        $display("Test %0d: Negative x Negative (-12 * -12)", test_num);
        #1;

        check_outputs(36'sd144);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        A = 18'sd12345;
        B = 18'sd0;
        @(posedge CLK);
        #1;
        $display("Test %0d: Multiply by Zero (12345 * 0)", test_num);
        #1;

        check_outputs(36'sd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        reset_dut();
        A = 18'h1FFFF;
        B = 18'sd2;
        @(posedge CLK);
        #1;
        $display("Test %0d: Max Positive x 2 (131071 * 2)", test_num);
        #1;

        check_outputs(36'sd262142);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        reset_dut();
        A = 18'h20000;
        B = 18'sd2;
        @(posedge CLK);
        #1;
        $display("Test %0d: Max Negative x 2 (-131072 * 2)", test_num);
        #1;

        check_outputs(-36'sd262144);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        reset_dut();
        A = 18'h20000;
        B = 18'h20000;
        @(posedge CLK);
        #1;
        $display("Test %0d: Large Neg x Large Neg (-131072 * -131072)", test_num);
        #1;

        check_outputs(36'sd17179869184);
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
        input [35:0] expected_Z;
        begin
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
        $dumpvars(0,A, B, CLK, RST, Z);
    end

endmodule
