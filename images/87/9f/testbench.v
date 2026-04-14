`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in1;
    reg in2;
    reg [3:0] state;
    wire [3:0] next_state;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .state(state),
        .next_state(next_state),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: State P transitions (in1=0, in2=0 -> Q)", test_num);
            state = 4'b0001; in1 = 0; in2 = 0;
            #1;

            check_outputs(4'b0010, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: State P transitions (in1=1, in2=0 -> R)", test_num);
            state = 4'b0001; in1 = 1; in2 = 0;
            #1;

            check_outputs(4'b0100, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: State P transitions (in1=0, in2=1 -> S)", test_num);
            state = 4'b0001; in1 = 0; in2 = 1;
            #1;

            check_outputs(4'b1000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: State P transitions (in1=1, in2=1 -> P)", test_num);
            state = 4'b0001; in1 = 1; in2 = 1;
            #1;

            check_outputs(4'b0001, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: State Q transitions (in1=0, in2=0 -> S)", test_num);
            state = 4'b0010; in1 = 0; in2 = 0;
            #1;

            check_outputs(4'b1000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: State Q transitions (in1=1, in2=0 -> P)", test_num);
            state = 4'b0010; in1 = 1; in2 = 0;
            #1;

            check_outputs(4'b0001, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: State Q transitions (in1=0, in2=1 -> R)", test_num);
            state = 4'b0010; in1 = 0; in2 = 1;
            #1;

            check_outputs(4'b0100, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: State Q transitions (in1=1, in2=1 -> Q)", test_num);
            state = 4'b0010; in1 = 1; in2 = 1;
            #1;

            check_outputs(4'b0010, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: State R transitions (in1=0, in2=0 -> P)", test_num);
            state = 4'b0100; in1 = 0; in2 = 0;
            #1;

            check_outputs(4'b0001, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: State R transitions (in1=1, in2=0 -> S)", test_num);
            state = 4'b0100; in1 = 1; in2 = 0;
            #1;

            check_outputs(4'b1000, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test %0d: State R transitions (in1=0, in2=1 -> Q)", test_num);
            state = 4'b0100; in1 = 0; in2 = 1;
            #1;

            check_outputs(4'b0010, 1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test %0d: State R transitions (in1=1, in2=1 -> R)", test_num);
            state = 4'b0100; in1 = 1; in2 = 1;
            #1;

            check_outputs(4'b0100, 1'b0);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            $display("Test %0d: State S transitions (in1=0, in2=0 -> R)", test_num);
            state = 4'b1000; in1 = 0; in2 = 0;
            #1;

            check_outputs(4'b0100, 1'b1);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            $display("Test %0d: State S transitions (in1=1, in2=0 -> Q)", test_num);
            state = 4'b1000; in1 = 1; in2 = 0;
            #1;

            check_outputs(4'b0010, 1'b1);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            $display("Test %0d: State S transitions (in1=0, in2=1 -> P)", test_num);
            state = 4'b1000; in1 = 0; in2 = 1;
            #1;

            check_outputs(4'b0001, 1'b1);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            $display("Test %0d: State S transitions (in1=1, in2=1 -> S)", test_num);
            state = 4'b1000; in1 = 1; in2 = 1;
            #1;

            check_outputs(4'b1000, 1'b1);
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
        input [3:0] expected_next_state;
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_next_state === (expected_next_state ^ next_state ^ expected_next_state) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: next_state=%h, out=%b",
                         next_state, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_state=%h, out=%b",
                         expected_next_state, expected_out);
                $display("  Got:      next_state=%h, out=%b",
                         next_state, out);
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
