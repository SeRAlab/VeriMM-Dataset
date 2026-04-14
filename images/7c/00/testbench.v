`timescale 1ns/1ps

module moore_machine_10_tb;

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
    moore_machine_10 dut (
        .in1(in1),
        .in2(in2),
        .state(state),
        .next_state(next_state),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: State A, in1=0, in2=0 -> next_state=B, out=0", test_num);

            state = 4'b0001; in1 = 0; in2 = 0;
            #1;

            check_outputs(4'b0010, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: State A, in1=1, in2=0 -> next_state=C, out=0", test_num);
            state = 4'b0001; in1 = 1; in2 = 0;
            #1;

            check_outputs(4'b0100, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: State B, in1=0, in2=1 -> next_state=D, out=1", test_num);
            state = 4'b0010; in1 = 0; in2 = 1;
            #1;

            check_outputs(4'b1000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: State B, in1=1, in2=0 -> next_state=A, out=1", test_num);
            state = 4'b0010; in1 = 1; in2 = 0;
            #1;

            check_outputs(4'b0001, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: State C, in2=0 -> next_state=D, out=1", test_num);
            state = 4'b0100; in1 = 0; in2 = 0;
            #1;

            check_outputs(4'b1000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: State C, in2=1 -> next_state=B, out=1", test_num);
            state = 4'b0100; in1 = 1; in2 = 1;
            #1;

            check_outputs(4'b0010, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: State D, in1=1 -> next_state=B, out=0", test_num);
            state = 4'b1000; in1 = 1; in2 = 0;
            #1;

            check_outputs(4'b0010, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: State D, in2=1, in1=0 -> next_state=A, out=0", test_num);
            state = 4'b1000; in1 = 0; in2 = 1;
            #1;

            check_outputs(4'b0001, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("moore_machine_10 Testbench");
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
