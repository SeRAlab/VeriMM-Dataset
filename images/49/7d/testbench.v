`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A1_N;
    reg A2_N;
    reg B1;
    reg B2;
    wire S1;
    wire S2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1_N(A1_N),
        .A2_N(A2_N),
        .B1(B1),
        .B2(B2),
        .S1(S1),
        .S2(S2)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A1_N = 1; A2_N = 1; B1 = 0; B2 = 0;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A1_N = 1; A2_N = 1; B1 = 1; B2 = 0;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A1_N = 1; A2_N = 1; B1 = 0; B2 = 1;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A1_N = 1; A2_N = 1; B1 = 1; B2 = 1;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A1_N = 0; A2_N = 1; B1 = 0; B2 = 0;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A1_N = 0; A2_N = 1; B1 = 1; B2 = 0;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A1_N = 0; A2_N = 1; B1 = 0; B2 = 1;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A1_N = 0; A2_N = 1; B1 = 1; B2 = 1;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        A1_N = 1; A2_N = 0; B1 = 0; B2 = 0;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        A1_N = 1; A2_N = 0; B1 = 1; B2 = 0;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        A1_N = 1; A2_N = 0; B1 = 0; B2 = 1;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        A1_N = 1; A2_N = 0; B1 = 1; B2 = 1;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        A1_N = 0; A2_N = 0; B1 = 0; B2 = 0;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        A1_N = 0; A2_N = 0; B1 = 1; B2 = 0;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase015;

    begin
        test_num = test_num + 1;
        A1_N = 0; A2_N = 0; B1 = 0; B2 = 1;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase016;

    begin
        test_num = test_num + 1;
        A1_N = 0; A2_N = 0; B1 = 1; B2 = 1;
        #1;

        check_outputs(0, 1);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_S1;
        input expected_S2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S1 === (expected_S1 ^ S1 ^ expected_S1) &&
                expected_S2 === (expected_S2 ^ S2 ^ expected_S2)) begin
                $display("PASS");
                $display("  Outputs: S1=%b, S2=%b",
                         S1, S2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S1=%b, S2=%b",
                         expected_S1, expected_S2);
                $display("  Got:      S1=%b, S2=%b",
                         S1, S2);
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
