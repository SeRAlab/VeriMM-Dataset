`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] state;
    wire Z11;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .state(state),
        .Z11(Z11)
    );
    task testcase001;

        begin
            test_num = 1;
            state = 3'b000;
            $display("Test %0d: state = %b (Expected: Z11=0)", test_num, state);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            state = 3'b001;
            $display("Test %0d: state = %b (LSB is 1, Expected: Z11=1)", test_num, state);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            state = 3'b011;
            $display("Test %0d: state = %b (LSB is 1, Expected: Z11=1)", test_num, state);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            state = 3'b101;
            $display("Test %0d: state = %b (LSB is 1, Expected: Z11=1)", test_num, state);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            state = 3'b111;
            $display("Test %0d: state = %b (LSB is 1, Expected: Z11=1)", test_num, state);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            state = 3'b010;
            $display("Test %0d: state = %b (Other pattern, Expected: Z11=x)", test_num, state);
            #1;

            check_outputs(1'bx);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            state = 3'b100;
            $display("Test %0d: state = %b (Other pattern, Expected: Z11=x)", test_num, state);
            #1;

            check_outputs(1'bx);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            state = 3'b110;
            $display("Test %0d: state = %b (Other pattern, Expected: Z11=x)", test_num, state);
            #1;

            check_outputs(1'bx);
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
        input expected_Z11;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z11 === (expected_Z11 ^ Z11 ^ expected_Z11)) begin
                $display("PASS");
                $display("  Outputs: Z11=%b",
                         Z11);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z11=%b",
                         expected_Z11);
                $display("  Got:      Z11=%b",
                         Z11);
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
