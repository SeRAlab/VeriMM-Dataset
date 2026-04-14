`timescale 1ns/1ps

module two_bit_adder_tb;

    // Testbench signals (combinational circuit)
    reg A0;
    reg A1;
    reg B0;
    reg B1;
    wire C;
    wire S0;
    wire S1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    two_bit_adder dut (
        .A0(A0),
        .A1(A1),
        .B0(B0),
        .B1(B1),
        .C(C),
        .S0(S0),
        .S1(S1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 0 + 0 = 0 (00 + 00 = 000)", test_num);
            A1 = 0; A0 = 0; B1 = 0; B0 = 0;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 1 + 0 = 1 (01 + 00 = 001)", test_num);
            A1 = 0; A0 = 1; B1 = 0; B0 = 0;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 1 + 1 = 2 (01 + 01 = 010)", test_num);
            A1 = 0; A0 = 1; B1 = 0; B0 = 1;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 2 + 1 = 3 (10 + 01 = 011)", test_num);
            A1 = 1; A0 = 0; B1 = 0; B0 = 1;
            #1;

            check_outputs(0, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 2 + 2 = 4 (10 + 10 = 100)", test_num);
            A1 = 1; A0 = 0; B1 = 1; B0 = 0;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 3 + 1 = 4 (11 + 01 = 100)", test_num);
            A1 = 1; A0 = 1; B1 = 0; B0 = 1;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 3 + 2 = 5 (11 + 10 = 101)", test_num);
            A1 = 1; A0 = 1; B1 = 1; B0 = 0;
            #1;

            check_outputs(1, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 3 + 3 = 6 (11 + 11 = 110)", test_num);
            A1 = 1; A0 = 1; B1 = 1; B0 = 1;
            #1;

            check_outputs(1, 0, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 0 + 3 = 3 (00 + 11 = 011)", test_num);
            A1 = 0; A0 = 0; B1 = 1; B0 = 1;
            #1;

            check_outputs(0, 1, 1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 1 + 2 = 3 (01 + 10 = 011)", test_num);
            A1 = 0; A0 = 1; B1 = 1; B0 = 0;
            #1;

            check_outputs(0, 1, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("two_bit_adder Testbench");
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
        input expected_C;
        input expected_S0;
        input expected_S1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_S0 === (expected_S0 ^ S0 ^ expected_S0) &&
                expected_S1 === (expected_S1 ^ S1 ^ expected_S1)) begin
                $display("PASS");
                $display("  Outputs: C=%b, S0=%b, S1=%b",
                         C, S0, S1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b, S0=%b, S1=%b",
                         expected_C, expected_S0, expected_S1);
                $display("  Got:      C=%b, S0=%b, S1=%b",
                         C, S0, S1);
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
