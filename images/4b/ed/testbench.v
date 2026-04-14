`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] cnt_V;
    reg [5:0] rate_V;
    reg [2:0] state_V;
    wire step_V;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cnt_V(cnt_V),
        .rate_V(rate_V),
        .state_V(state_V),
        .step_V(step_V)
    );
    task testcase001;

        begin
            test_num = 1;
            state_V = 3'b000;
            rate_V  = 6'b000000;
            cnt_V   = 3'b000;
            $display("Test %0d: All Zeros - State: %b, Rate: %b, Cnt: %b", test_num, state_V, rate_V, cnt_V);
            #1;

            check_outputs(calc_expected(state_V, rate_V, cnt_V));
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            state_V = 3'b111;
            rate_V  = 6'b000000;
            cnt_V   = 3'b010;
            $display("Test %0d: Max State - State: %b, Rate: %b, Cnt: %b", test_num, state_V, rate_V, cnt_V);
            #1;

            check_outputs(calc_expected(state_V, rate_V, cnt_V));
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            state_V = 3'b000;
            rate_V  = 6'b111111;
            cnt_V   = 3'b101;
            $display("Test %0d: Max Rate - State: %b, Rate: %b, Cnt: %b", test_num, state_V, rate_V, cnt_V);
            #1;

            check_outputs(calc_expected(state_V, rate_V, cnt_V));
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            state_V = 3'b010;
            rate_V  = 6'b101010;
            cnt_V   = 3'b111;
            $display("Test %0d: Mixed Values - State: %b, Rate: %b, Cnt: %b", test_num, state_V, rate_V, cnt_V);
            #1;

            check_outputs(calc_expected(state_V, rate_V, cnt_V));
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            state_V = 3'b100;
            rate_V  = 6'b011001;
            cnt_V   = 3'b001;
            $display("Test %0d: Mid Selection - State: %b, Rate: %b, Cnt: %b", test_num, state_V, rate_V, cnt_V);
            #1;

            check_outputs(calc_expected(state_V, rate_V, cnt_V));
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            state_V = 3'b001;
            rate_V  = 6'b110011;
            cnt_V   = 3'b100;
            $display("Test %0d: Pattern Test - State: %b, Rate: %b, Cnt: %b", test_num, state_V, rate_V, cnt_V);
            #1;

            check_outputs(calc_expected(state_V, rate_V, cnt_V));
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            state_V = 3'b011;
            rate_V  = 6'b001110;
            cnt_V   = 3'b011;
            $display("Test %0d: Bit Boundary - State: %b, Rate: %b, Cnt: %b", test_num, state_V, rate_V, cnt_V);
            #1;

            check_outputs(calc_expected(state_V, rate_V, cnt_V));
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            state_V = 3'b101;
            rate_V  = 6'b111111;
            cnt_V   = 3'b000;
            $display("Test %0d: LSB Selection - State: %b, Rate: %b, Cnt: %b", test_num, state_V, rate_V, cnt_V);
            #1;

            check_outputs(calc_expected(state_V, rate_V, cnt_V));
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
        input expected_step_V;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_step_V === (expected_step_V ^ step_V ^ expected_step_V)) begin
                $display("PASS");
                $display("  Outputs: step_V=%b",
                         step_V);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: step_V=%b",
                         expected_step_V);
                $display("  Got:      step_V=%b",
                         step_V);
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
