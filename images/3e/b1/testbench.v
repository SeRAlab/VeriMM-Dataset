`timescale 1ns/1ps

module monte_carlo_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] random_number;
    wire is_even;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    monte_carlo dut (
        .random_number(random_number),
        .is_even(is_even)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input = 0 (Even)", test_num);
            random_number = 5'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input = 1 (Odd)", test_num);
            random_number = 5'd1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input = 15 (Odd)", test_num);
            random_number = 5'd15;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input = 16 (Even)", test_num);
            random_number = 5'd16;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input = 30 (Even)", test_num);
            random_number = 5'd30;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input = 31 (Odd)", test_num);
            random_number = 5'd31;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input = 22 (Even)", test_num);
            random_number = 5'd22;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input = 9 (Odd)", test_num);
            random_number = 5'd9;
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
        $display("monte_carlo Testbench");
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
        input expected_is_even;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_is_even === (expected_is_even ^ is_even ^ expected_is_even)) begin
                $display("PASS");
                $display("  Outputs: is_even=%b",
                         is_even);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_even=%b",
                         expected_is_even);
                $display("  Got:      is_even=%b",
                         is_even);
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
