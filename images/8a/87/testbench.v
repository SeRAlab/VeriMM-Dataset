`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in;
    reg [2:0] state;
    wire L_next;
    wire M_next;
    wire N_next;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .state(state),
        .L_next(L_next),
        .M_next(M_next),
        .N_next(N_next),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: State L (One-hot 001), Input 0 -> Expect L_next=1, M_next=0, N_next=0, out=1", test_num);

            state = 3'b001;
            in = 0;

            #1;


            check_outputs(1, 0, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: State L (One-hot 001), Input 1 -> Expect L_next=0, M_next=1, N_next=0, out=1", test_num);

            state = 3'b001;
            in = 1;

            #1;


            check_outputs(0, 1, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: State M (One-hot 010), Input 0 -> Expect L_next=0, M_next=0, N_next=1, out=1", test_num);

            state = 3'b010;
            in = 0;

            #1;


            check_outputs(0, 0, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: State M (One-hot 010), Input 1 -> Expect L_next=1, M_next=0, N_next=0, out=1", test_num);

            state = 3'b010;
            in = 1;

            #1;


            check_outputs(1, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: State N (One-hot 100), Input 0 -> Expect L_next=0, M_next=1, N_next=0, out=0", test_num);

            state = 3'b100;
            in = 0;

            #1;


            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: State N (One-hot 100), Input 1 -> Expect L_next=0, M_next=0, N_next=1, out=0", test_num);

            state = 3'b100;
            in = 1;

            #1;


            check_outputs(0, 0, 1, 0);
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
        input expected_L_next;
        input expected_M_next;
        input expected_N_next;
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_L_next === (expected_L_next ^ L_next ^ expected_L_next) &&
                expected_M_next === (expected_M_next ^ M_next ^ expected_M_next) &&
                expected_N_next === (expected_N_next ^ N_next ^ expected_N_next) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: L_next=%b, M_next=%b, N_next=%b, out=%b",
                         L_next, M_next, N_next, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: L_next=%b, M_next=%b, N_next=%b, out=%b",
                         expected_L_next, expected_M_next, expected_N_next, expected_out);
                $display("  Got:      L_next=%b, M_next=%b, N_next=%b, out=%b",
                         L_next, M_next, N_next, out);
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
