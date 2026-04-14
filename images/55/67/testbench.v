`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg D0;
    reg D1;
    reg D2;
    reg D3;
    reg ctrl0;
    reg ctrl1;
    wire S;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D0(D0),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .ctrl0(ctrl0),
        .ctrl1(ctrl1),
        .S(S),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Select D0 (1)", test_num);
        D0 = 1; D1 = 0; D2 = 0; D3 = 0;
        ctrl1 = 0; ctrl0 = 0;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Select D0 (0)", test_num);
        D0 = 0; D1 = 1; D2 = 1; D3 = 1;
        ctrl1 = 0; ctrl0 = 0;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Select D1 (1)", test_num);
        D0 = 0; D1 = 1; D2 = 0; D3 = 0;
        ctrl1 = 0; ctrl0 = 1;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Select D1 (0)", test_num);
        D0 = 1; D1 = 0; D2 = 1; D3 = 1;
        ctrl1 = 0; ctrl0 = 1;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Select D2 (1)", test_num);
        D0 = 0; D1 = 0; D2 = 1; D3 = 0;
        ctrl1 = 1; ctrl0 = 0;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Select D2 (0)", test_num);
        D0 = 1; D1 = 1; D2 = 0; D3 = 1;
        ctrl1 = 1; ctrl0 = 0;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Select D3 (1)", test_num);
        D0 = 0; D1 = 0; D2 = 0; D3 = 1;
        ctrl1 = 1; ctrl0 = 1;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Select D3 (0)", test_num);
        D0 = 1; D1 = 1; D2 = 1; D3 = 0;
        ctrl1 = 1; ctrl0 = 1;
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
        input expected_S;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: S=%b, valid=%b",
                         S, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%b, valid=%b",
                         expected_S, expected_valid);
                $display("  Got:      S=%b, valid=%b",
                         S, valid);
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
