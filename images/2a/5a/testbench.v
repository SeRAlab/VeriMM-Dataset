`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] current_value;
    reg [15:0] learning_rate;
    wire [15:0] next_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .current_value(current_value),
        .learning_rate(learning_rate),
        .next_value(next_value)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Standard operation", test_num);
            current_value = 16'd100;
            learning_rate = 16'd10;
            #1;

            check_outputs(16'd90);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Zero Learning Rate", test_num);
            current_value = 16'h1234;
            learning_rate = 16'h0000;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Result equals zero", test_num);
            current_value = 16'h00FF;
            learning_rate = 16'h00FF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Underflow wrap-around", test_num);
            current_value = 16'h0000;
            learning_rate = 16'h0001;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: High values", test_num);
            current_value = 16'hFFFF;
            learning_rate = 16'h8000;
            #1;

            check_outputs(16'h7FFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Max value minus max value", test_num);
            current_value = 16'hFFFF;
            learning_rate = 16'hFFFF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Minimum non-zero change", test_num);
            current_value = 16'h0001;
            learning_rate = 16'h0001;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gradient_descent Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [15:0] expected_next_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_next_value === (expected_next_value ^ next_value ^ expected_next_value)) begin
                $display("PASS");
                $display("  Outputs: next_value=%h",
                         next_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_value=%h",
                         expected_next_value);
                $display("  Got:      next_value=%h",
                         next_value);
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
