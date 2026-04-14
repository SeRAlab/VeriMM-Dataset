`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Z(Z)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Addition Trigger ({A,B}=0x00AB)", test_num);
        A = 8'h00; B = 8'hAB;
        #1;

        check_outputs(8'hAB);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Subtraction Trigger ({A,B}=0x00AA)", test_num);
        A = 8'h00; B = 8'hAA;
        #1;

        check_outputs(8'h56);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Multiplication Trigger ({A,B}=0x0050)", test_num);
        A = 8'h00; B = 8'h50;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Division Trigger ({A,B}=0x0032)", test_num);
        A = 8'h00; B = 8'h32;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: No Match (Random values)", test_num);
        A = 8'h12; B = 8'h34;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Near Miss (A=0x01, B=0xAB)", test_num);
        A = 8'h01; B = 8'hAB;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Swapped Order (A=0xAB, B=0x00)", test_num);
        A = 8'hAB; B = 8'h00;
        #1;

        check_outputs(8'h00);
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
        input [7:0] expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
