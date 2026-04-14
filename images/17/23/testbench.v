`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] max_weight;
    reg [4:0] weights;
    wire [4:0] optimal_portfolio;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .max_weight(max_weight),
        .weights(weights),
        .optimal_portfolio(optimal_portfolio)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: weights < max_weight", test_num);
            weights = 5'd10;
            max_weight = 5'd20;
            #1;

            check_outputs(5'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: weights == max_weight", test_num);
            weights = 5'd15;
            max_weight = 5'd15;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: weights > max_weight", test_num);
            weights = 5'd25;
            max_weight = 5'd20;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: weights is zero", test_num);
            weights = 5'd0;
            max_weight = 5'd10;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: max_weight is zero, weights > 0", test_num);
            weights = 5'd5;
            max_weight = 5'd0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both zero", test_num);
            weights = 5'd0;
            max_weight = 5'd0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum possible values (31)", test_num);
            weights = 5'd31;
            max_weight = 5'd31;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum weight over maximum", test_num);
            weights = 5'd1;
            max_weight = 5'd0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large weights over limit", test_num);
            weights = 5'd31;
            max_weight = 5'd15;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Typical valid portfolio", test_num);
            weights = 5'd22;
            max_weight = 5'd31;
            #1;

            check_outputs(5'd22);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("portfolio_optimizer Testbench");
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
        input [4:0] expected_optimal_portfolio;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_optimal_portfolio === (expected_optimal_portfolio ^ optimal_portfolio ^ expected_optimal_portfolio)) begin
                $display("PASS");
                $display("  Outputs: optimal_portfolio=%h",
                         optimal_portfolio);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: optimal_portfolio=%h",
                         expected_optimal_portfolio);
                $display("  Got:      optimal_portfolio=%h",
                         optimal_portfolio);
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
