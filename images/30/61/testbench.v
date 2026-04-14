`timescale 1ns/1ps

module monte_carlo_simulation_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] random_number;
    wire in_range;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    monte_carlo_simulation dut (
        .random_number(random_number),
        .in_range(in_range)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing lower out-of-range value (0)", test_num);
            random_number = 5'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing lower out-of-range boundary (9)", test_num);
            random_number = 5'd9;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing lower boundary (10)", test_num);
            random_number = 5'd10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing middle of range (15)", test_num);
            random_number = 5'd15;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing upper boundary (20)", test_num);
            random_number = 5'd20;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing upper out-of-range boundary (21)", test_num);
            random_number = 5'd21;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing upper limit (31)", test_num);
            random_number = 5'd31;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random value in range (12)", test_num);
            random_number = 5'd12;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random value out of range (5)", test_num);
            random_number = 5'd5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("monte_carlo_simulation Testbench");
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
        input expected_in_range;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_in_range === (expected_in_range ^ in_range ^ expected_in_range)) begin
                $display("PASS");
                $display("  Outputs: in_range=%b",
                         in_range);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: in_range=%b",
                         expected_in_range);
                $display("  Got:      in_range=%b",
                         in_range);
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
