`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CI;
    reg [1:0] G;
    reg [1:0] P;
    wire [1:0] CO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CI(CI),
        .G(G),
        .P(P),
        .CO(CO)
    );
    task testcase001;

        begin
            test_num = 1;
            CI = 0; G = 2'b00; P = 2'b00;
            $display("Test %0d: No activity (CI=0, G=00, P=00)", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            CI = 1; G = 2'b00; P = 2'b00;
            $display("Test %0d: Carry-in blocked by zero propagate (CI=1, G=00, P=00)", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            CI = 0; G = 2'b01; P = 2'b00;
            $display("Test %0d: G0 generates carry (CI=0, G=01, P=00)", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            CI = 1; G = 2'b00; P = 2'b01;
            $display("Test %0d: CI propagates through P0 (CI=1, G=00, P=01)", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            CI = 0; G = 2'b01; P = 2'b10;
            $display("Test %0d: G0 generates, P1 propagates to CO[1] (CI=0, G=01, P=10)", test_num);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            CI = 1; G = 2'b00; P = 2'b11;
            $display("Test %0d: CI propagates through P0 and P1 (CI=1, G=00, P=11)", test_num);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            CI = 0; G = 2'b10; P = 2'b00;
            $display("Test %0d: G1 generates carry (CI=0, G=10, P=00)", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            CI = 1; G = 2'b10; P = 2'b00;
            $display("Test %0d: G1 generates carry with CI high but P0 low (CI=1, G=10, P=00)", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            CI = 1; G = 2'b00; P = 2'b10;
            $display("Test %0d: CI propagates through P1 only (should not reach CO[1]) (CI=1, G=00, P=10)", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            CI = 1; G = 2'b11; P = 2'b11;
            $display("Test %0d: All signals high (CI=1, G=11, P=11)", test_num);
            #1;

            check_outputs(2'b11);
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
        input [1:0] expected_CO;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CO === (expected_CO ^ CO ^ expected_CO)) begin
                $display("PASS");
                $display("  Outputs: CO=%h",
                         CO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CO=%h",
                         expected_CO);
                $display("  Got:      CO=%h",
                         CO);
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
