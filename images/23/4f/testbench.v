`timescale 1ns/1ps

module hazard_detector_adder_tb;

    // Testbench signals (combinational circuit)
    reg A0;
    reg A1;
    reg B0;
    reg B1;
    wire C_out;
    wire S0;
    wire S1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hazard_detector_adder dut (
        .A0(A0),
        .A1(A1),
        .B0(B0),
        .B1(B1),
        .C_out(C_out),
        .S0(S0),
        .S1(S1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=00, B=00", test_num);
            A1 = 0; A0 = 0; B1 = 0; B0 = 0;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=01, B=01", test_num);
            A1 = 0; A0 = 1; B1 = 0; B0 = 1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=10, B=01", test_num);
            A1 = 1; A0 = 0; B1 = 0; B0 = 1;
            #1;

            check_outputs(0, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=11, B=01", test_num);
            A1 = 1; A0 = 1; B1 = 0; B0 = 1;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=10, B=10", test_num);
            A1 = 1; A0 = 0; B1 = 1; B0 = 0;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=11, B=11", test_num);
            A1 = 1; A0 = 1; B1 = 1; B0 = 1;
            #1;

            check_outputs(1, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=00, B=11", test_num);
            A1 = 0; A0 = 0; B1 = 1; B0 = 1;
            #1;

            check_outputs(0, 1, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A=10, B=11", test_num);
            A1 = 1; A0 = 0; B1 = 1; B0 = 1;
            #1;

            check_outputs(1, 1, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hazard_detector_adder Testbench");
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
        input expected_C_out;
        input expected_S0;
        input expected_S1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C_out === (expected_C_out ^ C_out ^ expected_C_out) &&
                expected_S0 === (expected_S0 ^ S0 ^ expected_S0) &&
                expected_S1 === (expected_S1 ^ S1 ^ expected_S1)) begin
                $display("PASS");
                $display("  Outputs: C_out=%b, S0=%b, S1=%b",
                         C_out, S0, S1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C_out=%b, S0=%b, S1=%b",
                         expected_C_out, expected_S0, expected_S1);
                $display("  Got:      C_out=%b, S0=%b, S1=%b",
                         C_out, S0, S1);
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
