`timescale 1ns/1ps

module washing_machine_controller_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg start;
    reg [3:0] state;
    wire [3:0] next_state;
    wire rinsing;
    wire spinning;
    wire washing;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    washing_machine_controller dut (
        .clk(clk),
        .start(start),
        .state(state),
        .next_state(next_state),
        .rinsing(rinsing),
        .spinning(spinning),
        .washing(washing)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: OFF state, start=0", test_num);
            state = 4'b0001;
            start = 0;

            #1;


            check_outputs(4'b0001, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: OFF state, start=1", test_num);
            state = 4'b0001;
            start = 1;

            #1;


            check_outputs(4'b0010, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: WASH state", test_num);
            state = 4'b0010;
            start = 0;

            #1;


            check_outputs(4'b0100, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: RINSE state", test_num);
            state = 4'b0100;
            start = 0;

            #1;


            check_outputs(4'b1000, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: SPIN state", test_num);
            state = 4'b1000;
            start = 0;

            #1;


            check_outputs(4'b0001, 0, 1, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("washing_machine_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_rinsing;
        input expected_spinning;
        input expected_washing;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_next_state === (expected_next_state ^ next_state ^ expected_next_state) &&
                expected_rinsing === (expected_rinsing ^ rinsing ^ expected_rinsing) &&
                expected_spinning === (expected_spinning ^ spinning ^ expected_spinning) &&
                expected_washing === (expected_washing ^ washing ^ expected_washing)) begin
                $display("PASS");
                $display("  Outputs: next_state=%h, rinsing=%b, spinning=%b, washing=%b",
                         next_state, rinsing, spinning, washing);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_state=%h, rinsing=%b, spinning=%b, washing=%b",
                         expected_next_state, expected_rinsing, expected_spinning, expected_washing);
                $display("  Got:      next_state=%h, rinsing=%b, spinning=%b, washing=%b",
                         next_state, rinsing, spinning, washing);
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
