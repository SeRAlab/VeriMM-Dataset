`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] D;
    reg LD;
    reg SEL;
    reg SL;
    reg SR;
    wire [7:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .D(D),
        .LD(LD),
        .SEL(SEL),
        .SL(SL),
        .SR(SR),
        .P(P)
    );

    // Clock generation (10ns period)
    initial begin
        LD = 0;
        forever #5 LD = ~LD;
    end

        task reset_dut;

    begin
        A = 0; B = 0; D = 0; SEL = 0; SL = 0; SR = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %03d: Positive Multiplication (3x2), SEL=0, Load D=1", test_num);
        A = 4'd3; B = 4'd2; D = 4'b0001; SEL = 0; SL = 0; SR = 0;
        #10;
        #1;

        check_outputs(8'h0D);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %03d: Positive Multiplication (3x2), SEL=1, Load D=8", test_num);
        A = 4'd3; B = 4'd2; D = 4'b1000; SEL = 1; SL = 0; SR = 0;
        #10;
        #1;

        check_outputs(8'h86);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %03d: Signed Multiplication (-2x3), SEL=0, Load D=0", test_num);
        A = 4'hE; B = 4'h3; D = 4'b0000; SEL = 0; SL = 0; SR = 0;
        #10;
        #1;

        check_outputs(8'hF4);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %03d: Shift Left Operation", test_num);
        D = 4'b0100; SL = 0; SR = 0; #10;
        SL = 1; SR = 0; #10;
        A = 0; B = 0; SEL = 1;
        #5;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %03d: Shift Right Operation", test_num);
        D = 4'b0010; SL = 0; SR = 0; #10;
        SL = 0; SR = 1; #10;
        A = 0; B = 0; SEL = 0;
        #5;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %03d: Boundary Signed Multiplication (-8x7)", test_num);
        A = 4'h8; B = 4'h7; D = 4'b0000; SEL = 1; SL = 0; SR = 0;
        #10;
        #1;

        check_outputs(8'h48);
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
        input [7:0] expected_P;
        begin
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
        $dumpvars(0,A, B, D, LD, SEL, SL, SR, P);
    end

endmodule
