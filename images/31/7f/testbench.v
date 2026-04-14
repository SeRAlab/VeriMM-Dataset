`timescale 1ns/1ps

module portfolio_allocation_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] budget;
    reg [3:0] weight1;
    reg [3:0] weight2;
    reg [3:0] weight3;
    wire [3:0] allocation1;
    wire [3:0] allocation2;
    wire [3:0] allocation3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_allocation dut (
        .budget(budget),
        .weight1(weight1),
        .weight2(weight2),
        .weight3(weight3),
        .allocation1(allocation1),
        .allocation2(allocation2),
        .allocation3(allocation3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero weights", test_num);
            weight1 = 4'd0;
            weight2 = 4'd0;
            weight3 = 4'd0;
            budget  = 4'd10;
            #1;

            check_outputs(4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single asset dominant", test_num);
            weight1 = 4'd10;
            weight2 = 4'd0;
            weight3 = 4'd0;
            budget  = 4'd10;
            #1;

            check_outputs(4'd10, 4'd0, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Equal weights, divisible budget", test_num);
            weight1 = 4'd1;
            weight2 = 4'd1;
            weight3 = 4'd1;
            budget  = 4'd9;
            #1;

            check_outputs(4'd3, 4'd3, 4'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Equal weights, budget with truncation", test_num);
            weight1 = 4'd1;
            weight2 = 4'd1;
            weight3 = 4'd1;
            budget  = 4'd10;

            #1;


            check_outputs(4'd3, 4'd3, 4'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Diverse weights, clean division", test_num);
            weight1 = 4'd1;
            weight2 = 4'd2;
            weight3 = 4'd3;
            budget  = 4'd12;

            #1;


            check_outputs(4'd2, 4'd4, 4'd6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum weights and budget", test_num);
            weight1 = 4'd15;
            weight2 = 4'd15;
            weight3 = 4'd15;
            budget  = 4'd15;

            #1;


            check_outputs(4'd5, 4'd5, 4'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero budget", test_num);
            weight1 = 4'd5;
            weight2 = 4'd5;
            weight3 = 4'd5;
            budget  = 4'd0;
            #1;

            check_outputs(4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Small budget, large weights", test_num);
            weight1 = 4'd10;
            weight2 = 4'd10;
            weight3 = 4'd10;
            budget  = 4'd1;

            #1;


            check_outputs(4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Two weights active", test_num);
            weight1 = 4'd5;
            weight2 = 4'd10;
            weight3 = 4'd0;
            budget  = 4'd15;

            #1;


            check_outputs(4'd5, 4'd10, 4'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Prime numbers and truncation", test_num);
            weight1 = 4'd7;
            weight2 = 4'd2;
            weight3 = 4'd1;
            budget  = 4'd5;

            #1;


            check_outputs(4'd3, 4'd1, 4'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("portfolio_allocation Testbench");
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
        input [3:0] expected_allocation1;
        input [3:0] expected_allocation2;
        input [3:0] expected_allocation3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_allocation1 === (expected_allocation1 ^ allocation1 ^ expected_allocation1) &&
                expected_allocation2 === (expected_allocation2 ^ allocation2 ^ expected_allocation2) &&
                expected_allocation3 === (expected_allocation3 ^ allocation3 ^ expected_allocation3)) begin
                $display("PASS");
                $display("  Outputs: allocation1=%h, allocation2=%h, allocation3=%h",
                         allocation1, allocation2, allocation3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: allocation1=%h, allocation2=%h, allocation3=%h",
                         expected_allocation1, expected_allocation2, expected_allocation3);
                $display("  Got:      allocation1=%h, allocation2=%h, allocation3=%h",
                         allocation1, allocation2, allocation3);
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
