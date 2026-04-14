`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg signal;
    reg [2:0] state;
    wire S0_next;
    wire S1_next;
    wire S2_next;
    wire detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .signal(signal),
        .state(state),
        .S0_next(S0_next),
        .S1_next(S1_next),
        .S2_next(S2_next),
        .detected(detected)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: State S0 (001), Signal 0", test_num);
            state = 3'b001;
            signal = 0;

            #1;


            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: State S0 (001), Signal 1", test_num);
            state = 3'b001;
            signal = 1;

            #1;


            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: State S1 (010), Signal 0", test_num);
            state = 3'b010;
            signal = 0;

            #1;


            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: State S1 (010), Signal 1", test_num);
            state = 3'b010;
            signal = 1;

            #1;


            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: State S2 (100), Signal 0", test_num);
            state = 3'b100;
            signal = 0;

            #1;


            check_outputs(0, 1, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: State S2 (100), Signal 1", test_num);
            state = 3'b100;
            signal = 1;

            #1;


            check_outputs(0, 0, 1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Reset State (S0), Signal 0 Check", test_num);
            state = 3'b001;
            signal = 0;
            #1;

            check_outputs(1, 0, 0, 0);
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
        input expected_S0_next;
        input expected_S1_next;
        input expected_S2_next;
        input expected_detected;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S0_next === (expected_S0_next ^ S0_next ^ expected_S0_next) &&
                expected_S1_next === (expected_S1_next ^ S1_next ^ expected_S1_next) &&
                expected_S2_next === (expected_S2_next ^ S2_next ^ expected_S2_next) &&
                expected_detected === (expected_detected ^ detected ^ expected_detected)) begin
                $display("PASS");
                $display("  Outputs: S0_next=%b, S1_next=%b, S2_next=%b, detected=%b",
                         S0_next, S1_next, S2_next, detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S0_next=%b, S1_next=%b, S2_next=%b, detected=%b",
                         expected_S0_next, expected_S1_next, expected_S2_next, expected_detected);
                $display("  Got:      S0_next=%b, S1_next=%b, S2_next=%b, detected=%b",
                         S0_next, S1_next, S2_next, detected);
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
