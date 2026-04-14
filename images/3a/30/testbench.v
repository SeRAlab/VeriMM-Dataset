`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] hidden_state;
    reg [3:0] input_data;
    wire [3:0] new_hidden_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .hidden_state(hidden_state),
        .input_data(input_data),
        .new_hidden_state(new_hidden_state)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (Zero Input, Zero State)", test_num);
            input_data = 4'b0000;
            hidden_state = 4'b0000;

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input only (Full Input, Zero State)", test_num);
            input_data = 4'b1111;
            hidden_state = 4'b0000;

            #1;


            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hidden state only (Zero Input, Full State)", test_num);
            input_data = 4'b0000;
            hidden_state = 4'b1111;

            #1;


            check_outputs(4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bit Pattern 1", test_num);
            input_data = 4'b1010;
            hidden_state = 4'b0101;

            #1;


            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Matching Inputs (Result should be Zero)", test_num);
            input_data = 4'b1100;
            hidden_state = 4'b1100;

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Bit Pattern 1", test_num);
            input_data = 4'b1001;
            hidden_state = 4'b0110;

            #1;


            check_outputs(4'b1111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Bit Pattern 2", test_num);
            input_data = 4'b0111;
            hidden_state = 4'b0010;

            #1;


            check_outputs(4'b0101);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit Interaction", test_num);
            input_data = 4'b0001;
            hidden_state = 4'b1000;

            #1;


            check_outputs(4'b1001);
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
