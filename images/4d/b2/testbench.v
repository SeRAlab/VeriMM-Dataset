`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    reg E;
    reg F;
    reg G;
    reg H;
    wire X;

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
        .X(X)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All conditions False", test_num);

            A = 0; B = 1;
            C = 1; D = 1;
            E = 0; F = 0;
            G = 1; H = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Condition (A and B) is HIGH", test_num);
            A = 1; B = 1;
            C = 1; D = 0;
            E = 0; F = 0;
            G = 1; H = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Condition (C is LOW and D is HIGH) is HIGH", test_num);
            A = 0; B = 1;
            C = 0; D = 1;
            E = 1; F = 1;
            G = 1; H = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Condition (E and F different) is HIGH (E=1, F=0)", test_num);
            A = 0; B = 0;
            C = 1; D = 1;
            E = 1; F = 0;
            G = 1; H = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Condition (E and F different) is HIGH (E=0, F=1)", test_num);
            A = 0; B = 0;
            C = 1; D = 0;
            E = 0; F = 1;
            G = 1; H = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Condition (G is LOW and H is HIGH) is HIGH", test_num);
            A = 0; B = 0;
            C = 1; D = 0;
            E = 1; F = 1;
            G = 0; H = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Multiple conditions HIGH (A&B and !G&H)", test_num);
            A = 1; B = 1;
            C = 1; D = 0;
            E = 0; F = 0;
            G = 0; H = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All inputs zero check", test_num);

            A = 0; B = 0; C = 0; D = 0; E = 0; F = 0; G = 0; H = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary check - C low but D low, G low but H low", test_num);
            A = 0; B = 1;
            C = 0; D = 0;
            E = 1; F = 1;
            G = 0; H = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All conditions true simultaneously", test_num);
            A = 1; B = 1;
            C = 0; D = 1;
            E = 1; F = 0;
            G = 0; H = 1;
            #1;

            check_outputs(1);
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
        input expected_X;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%b",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%b",
                         expected_X);
                $display("  Got:      X=%b",
                         X);
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
