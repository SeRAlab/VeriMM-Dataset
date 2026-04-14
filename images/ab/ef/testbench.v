`timescale 1ns/1ps

module mealy_machine_4_tb;

    // Testbench signals (combinational circuit)
    reg in1;
    reg in2;
    reg [2:0] state;
    wire [2:0] next_state;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mealy_machine_4 dut (
        .in1(in1),
        .in2(in2),
        .state(state),
        .next_state(next_state),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: State R, in1=0, in2=0", test_num);
            state = 3'b001;
            in1 = 1'b0;
            in2 = 1'b0;
            #1;

            check_outputs(3'b010, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: State R, in1=1, in2=0", test_num);
            state = 3'b001;
            in1 = 1'b1;
            in2 = 1'b0;
            #1;

            check_outputs(3'b100, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: State R, in1=1, in2=1", test_num);
            state = 3'b001;
            in1 = 1'b1;
            in2 = 1'b1;
            #1;

            check_outputs(3'b100, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: State S, in1=0, in2=1", test_num);
            state = 3'b010;
            in1 = 1'b0;
            in2 = 1'b1;
            #1;

            check_outputs(3'b001, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: State S, in1=1, in2=0", test_num);
            state = 3'b010;
            in1 = 1'b1;
            in2 = 1'b0;
            #1;

            check_outputs(3'b100, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: State S, in1=1, in2=1", test_num);
            state = 3'b010;
            in1 = 1'b1;
            in2 = 1'b1;
            #1;

            check_outputs(3'b100, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: State T, in2=0, in1=0", test_num);
            state = 3'b100;
            in1 = 1'b0;
            in2 = 1'b0;
            #1;

            check_outputs(3'b001, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: State T, in2=0, in1=1", test_num);
            state = 3'b100;
            in1 = 1'b1;
            in2 = 1'b0;
            #1;

            check_outputs(3'b001, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: State T, in2=1, in1=0", test_num);
            state = 3'b100;
            in1 = 1'b0;
            in2 = 1'b1;
            #1;

            check_outputs(3'b010, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: State T, in2=1, in1=1", test_num);
            state = 3'b100;
            in1 = 1'b1;
            in2 = 1'b1;
            #1;

            check_outputs(3'b010, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mealy_machine_4 Testbench");
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
        input [2:0] expected_next_state;
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
