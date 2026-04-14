`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg CIN;
    reg CLK;
    reg SUB;
    wire BORROW;
    wire [3:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CIN(CIN),
        .CLK(CLK),
        .SUB(SUB),
        .BORROW(BORROW),
        .SUM(SUM)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            CIN = 0;
            SUB = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            A = 4'd5;
            B = 4'd3;
            CIN = 1'b0;
            SUB = 1'b0;
            @(posedge CLK);
            #1;
            $display("Testcase %03d: Basic Addition (5 + 3)", test_num);
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            A = 4'd12;
            B = 4'd4;
            CIN = 1'b1;
            SUB = 1'b0;
            @(posedge CLK);
            #1;
            $display("Testcase %03d: Addition with Carry (12 + 4 + 1)", test_num);
            #1;

            check_outputs(1'b1, 4'd1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            A = 4'd10;
            B = 4'd4;
            CIN = 1'b0;
            SUB = 1'b1;
            @(posedge CLK);
            #1;
            $display("Testcase %03d: Basic Subtraction (10 - 4)", test_num);
            #1;

            check_outputs(1'b0, 4'd6);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            A = 4'd10;
            B = 4'd9;
            CIN = 1'b1;
            SUB = 1'b1;
            @(posedge CLK);
            #1;
            $display("Testcase %03d: Subtraction with CIN (10 - 9 - 1)", test_num);
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            A = 4'd2;
            B = 4'd5;
            CIN = 1'b0;
            SUB = 1'b1;
            @(posedge CLK);
            #1;
            $display("Testcase %03d: Subtraction with Borrow (2 - 5)", test_num);
            #1;

            check_outputs(1'b1, 4'd13);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            A = 4'd5;
            B = 4'd5;
            CIN = 1'b1;
            SUB = 1'b1;
            @(posedge CLK);
            #1;
            $display("Testcase %03d: Subtraction with CIN Borrow (5 - 5 - 1)", test_num);
            #1;

            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            A = 4'hf;
            B = 4'hf;
            CIN = 1'b1;
            SUB = 1'b0;
            @(posedge CLK);
            #1;
            $display("Testcase %03d: Max Addition (15 + 15 + 1)", test_num);
            #1;

            check_outputs(1'b1, 4'hf);
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
        input expected_BORROW;
        input [3:0] expected_SUM;
        begin
            if (expected_BORROW === (expected_BORROW ^ BORROW ^ expected_BORROW) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: BORROW=%b, SUM=%h",
                         BORROW, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BORROW=%b, SUM=%h",
                         expected_BORROW, expected_SUM);
                $display("  Got:      BORROW=%b, SUM=%h",
                         BORROW, SUM);
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
        $dumpvars(0,A, B, CIN, CLK, SUB, BORROW, SUM);
    end

endmodule
