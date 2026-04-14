`timescale 1ns/1ps

module state_space_controller_tb;

    // Testbench signals (combinational circuit)
    reg control_signal;
    reg [2:0] current_state;
    wire [2:0] next_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    state_space_controller dut (
        .control_signal(control_signal),
        .current_state(current_state),
        .next_state(next_state)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Control=0, State=000 -> Expected=000", test_num);
            control_signal = 1'b0;
            current_state = 3'b000;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Control=0, State=101 -> Expected=101", test_num);
            control_signal = 1'b0;
            current_state = 3'b101;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Control=0, State=111 -> Expected=111", test_num);
            control_signal = 1'b0;
            current_state = 3'b111;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Control=1, State=000 -> Expected=001", test_num);
            control_signal = 1'b1;
            current_state = 3'b000;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Control=1, State=011 -> Expected=100", test_num);
            control_signal = 1'b1;
            current_state = 3'b011;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Control=1, State=110 -> Expected=111", test_num);
            control_signal = 1'b1;
            current_state = 3'b110;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Control=1, State=111 -> Expected=000 (Wrap-around)", test_num);
            control_signal = 1'b1;
            current_state = 3'b111;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Control=1, State=100 -> Expected=101", test_num);
            control_signal = 1'b1;
            current_state = 3'b100;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Control=0, State=010 -> Expected=010", test_num);
            control_signal = 1'b0;
            current_state = 3'b010;
            #1;

            check_outputs(3'b010);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("state_space_controller Testbench");
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
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_next_state === (expected_next_state ^ next_state ^ expected_next_state)) begin
                $display("PASS");
                $display("  Outputs: next_state=%h",
                         next_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_state=%h",
                         expected_next_state);
                $display("  Got:      next_state=%h",
                         next_state);
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
