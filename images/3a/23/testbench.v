`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] weight1;
    reg [4:0] weight2;
    reg [4:0] weight3;
    wire [7:0] expected_return;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .weight1(weight1),
        .weight2(weight2),
        .weight3(weight3),
        .expected_return(expected_return)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: 20%% Weight on Asset 1 (10%% Return)");
            weight1 = 5'd20; weight2 = 5'd0; weight3 = 5'd0;

            #1;


            check_outputs(8'd2);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: 20%% Weight on Asset 2 (15%% Return)");
            weight1 = 5'd0; weight2 = 5'd20; weight3 = 5'd0;

            #1;


            check_outputs(8'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: 20%% Weight on Asset 3 (20%% Return)");
            weight1 = 5'd0; weight2 = 5'd0; weight3 = 5'd20;

            #1;


            check_outputs(8'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Zero weight distribution");
            weight1 = 5'd0; weight2 = 5'd0; weight3 = 5'd0;

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Mixed weights (15, 10, 5)");
            weight1 = 5'd15; weight2 = 5'd10; weight3 = 5'd5;

            #1;


            check_outputs(8'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Maximum 5-bit weights (31, 31, 31)");
            weight1 = 5'd31; weight2 = 5'd31; weight3 = 5'd31;


            #1;



            check_outputs(8'd13);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case 007: Truncation check (Expected return 3.75)");
            weight1 = 5'd5; weight2 = 5'd5; weight3 = 5'd12;

            #1;


            check_outputs(8'd3);
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
        input [7:0] expected_expected_return;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_expected_return === (expected_expected_return ^ expected_return ^ expected_expected_return)) begin
                $display("PASS");
                $display("  Outputs: expected_return=%h",
                         expected_return);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: expected_return=%h",
                         expected_expected_return);
                $display("  Got:      expected_return=%h",
                         expected_return);
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
