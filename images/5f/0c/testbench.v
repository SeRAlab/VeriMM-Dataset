`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    reg [1:0] Sel0;
    reg [1:0] Sel1;
    wire [3:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .Sel0(Sel0),
        .Sel1(Sel1),
        .Z(Z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;

            A = 4'hA; B = 4'h5; C = 4'h3; D = 4'hF;
            Sel1 = 1'b0; Sel0 = 1'b0;
            $display("Test Case 001: Selecting A (Input: %h, Sel: 00)", A);
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'hA; B = 4'h5; C = 4'h3; D = 4'hF;
            Sel1 = 1'b0; Sel0 = 1'b1;
            $display("Test Case 002: Selecting B (Input: %h, Sel: 01)", B);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'hA; B = 4'h5; C = 4'h3; D = 4'hF;
            Sel1 = 1'b1; Sel0 = 1'b0;
            $display("Test Case 003: Selecting C (Input: %h, Sel: 10)", C);
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'hA; B = 4'h5; C = 4'h3; D = 4'hF;
            Sel1 = 1'b1; Sel0 = 1'b1;
            $display("Test Case 004: Selecting D (Input: %h, Sel: 11)", D);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'hF; B = 4'hF; C = 4'hF; D = 4'hF;
            Sel1 = 1'b0; Sel0 = 1'b1;
            $display("Test Case 005: All Inputs 4'hF, Select B");
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'h0; B = 4'h0; C = 4'h0; D = 4'h0;
            Sel1 = 1'b1; Sel0 = 1'b0;
            $display("Test Case 006: All Inputs 4'h0, Select C");
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'b0001; B = 4'b0010; C = 4'b0100; D = 4'b1000;
            Sel1 = 1'b0; Sel0 = 1'b1;
            $display("Test Case 007: Walking Bits, Select B");
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 4'b0001; B = 4'b0010; C = 4'b0100; D = 4'b1000;
            Sel1 = 1'b1; Sel0 = 1'b1;
            $display("Test Case 008: Walking Bits, Select D");
            #1;

            check_outputs(4'b1000);
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
        input [3:0] expected_Z;
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
