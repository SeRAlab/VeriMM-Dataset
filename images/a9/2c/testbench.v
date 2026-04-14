`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    reg [1:0] E;
    reg [1:0] F;
    reg [1:0] G;
    reg [1:0] H;
    wire Y;

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
        .E(E),
        .F(F),
        .G(G),
        .H(H),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All inputs zero", test_num);
            A = 4'h0; B = 4'h0; C = 4'h0; D = 4'h0;
            E = 2'h0; F = 2'h0; G = 2'h0; H = 2'h0;
            expected_product = {A,B,C,D} * {E,F,G,H};
            expected_Y_val = expected_product[31];
            #1;

            check_outputs(expected_Y_val);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Maximum unsigned values", test_num);
            A = 4'hF; B = 4'hF; C = 4'hF; D = 4'hF;
            E = 2'h3; F = 2'h3; G = 2'h3; H = 2'h3;
            expected_product = {A,B,C,D} * {E,F,G,H};
            expected_Y_val = expected_product[31];
            #1;

            check_outputs(expected_Y_val);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating bit patterns", test_num);
            A = 4'hA; B = 4'hA; C = 4'hA; D = 4'hA;
            E = 2'h1; F = 2'h1; G = 2'h1; H = 2'h1;
            expected_product = {A,B,C,D} * {E,F,G,H};
            expected_Y_val = expected_product[31];
            #1;

            check_outputs(expected_Y_val);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Power of two (shifting check)", test_num);
            A = 4'h8; B = 4'h0; C = 4'h0; D = 4'h0;
            E = 2'h2; F = 2'h0; G = 2'h0; H = 2'h0;
            expected_product = {A,B,C,D} * {E,F,G,H};
            expected_Y_val = expected_product[31];
            #1;

            check_outputs(expected_Y_val);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mixed small values", test_num);
            A = 4'h1; B = 4'h2; C = 4'h3; D = 4'h4;
            E = 2'h0; F = 2'h1; G = 2'h2; H = 2'h3;
            expected_product = {A,B,C,D} * {E,F,G,H};
            expected_Y_val = expected_product[31];
            #1;

            check_outputs(expected_Y_val);
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
