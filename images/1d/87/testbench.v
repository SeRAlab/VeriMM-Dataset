`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] hidden_state;
    reg [3:0] input_vector;
    wire [3:0] new_hidden_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .hidden_state(hidden_state),
        .input_vector(input_vector),
        .new_hidden_state(new_hidden_state)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: All Zero Inputs", test_num);


            hidden_state = 4'b0000;
            input_vector = 4'b0000;
            #10;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Maximum Input Vector, Zero Hidden State", test_num);

            hidden_state = 4'b0000;
            input_vector = 4'b1111;
            #10;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Zero Input Vector, Maximum Hidden State", test_num);

            hidden_state = 4'b1111;
            input_vector = 4'b0000;
            #10;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Alternating Bit Patterns", test_num);

            hidden_state = 4'b1010;
            input_vector = 4'b0101;
            #10;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Full Saturation Test", test_num);

            hidden_state = 4'b1111;
            input_vector = 4'b1111;
            #10;
            #1;

            check_outputs(4'hF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rnn_cell Testbench");
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
        input [3:0] expected_new_hidden_state;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_new_hidden_state === (expected_new_hidden_state ^ new_hidden_state ^ expected_new_hidden_state)) begin
                $display("PASS");
                $display("  Outputs: new_hidden_state=%h",
                         new_hidden_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_hidden_state=%h",
                         expected_new_hidden_state);
                $display("  Got:      new_hidden_state=%h",
                         new_hidden_state);
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
