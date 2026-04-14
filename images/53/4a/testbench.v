`timescale 1ns/1ps

module fsm_logic_tb;

    // Testbench signals (combinational circuit)
    reg in;
    reg [2:0] state;
    wire A_next;
    wire B_next;
    wire C_next;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fsm_logic dut (
        .in(in),
        .state(state),
        .A_next(A_next),
        .B_next(B_next),
        .C_next(C_next),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: State A (001), Input 0");
            test_num = 1;
            state = 3'b001;
            in = 1'b0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: State A (001), Input 1");
            test_num = 2;
            state = 3'b001;
            in = 1'b1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: State B (010), Input 0");
            test_num = 3;
            state = 3'b010;
            in = 1'b0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: State B (010), Input 1");
            test_num = 4;
            state = 3'b010;
            in = 1'b1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: State C (100), Input 0");
            test_num = 5;
            state = 3'b100;
            in = 1'b0;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: State C (100), Input 1");
            test_num = 6;
            state = 3'b100;
            in = 1'b1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fsm_logic Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_A_next;
        input expected_B_next;
        input expected_C_next;
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A_next === (expected_A_next ^ A_next ^ expected_A_next) &&
                expected_B_next === (expected_B_next ^ B_next ^ expected_B_next) &&
                expected_C_next === (expected_C_next ^ C_next ^ expected_C_next) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: A_next=%b, B_next=%b, C_next=%b, out=%b",
                         A_next, B_next, C_next, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_next=%b, B_next=%b, C_next=%b, out=%b",
                         expected_A_next, expected_B_next, expected_C_next, expected_out);
                $display("  Got:      A_next=%b, B_next=%b, C_next=%b, out=%b",
                         A_next, B_next, C_next, out);
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
