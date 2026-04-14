`timescale 1ns/1ps

module portfolio_normalization_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] asset1;
    reg [3:0] asset2;
    reg [3:0] asset3;
    wire [3:0] normalized_weight;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_normalization dut (
        .asset1(asset1),
        .asset2(asset2),
        .asset3(asset3),
        .normalized_weight(normalized_weight)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sum is zero (0, 0, 0)", test_num);
            asset1 = 4'd0;
            asset2 = 4'd0;
            asset3 = 4'd0;

            #1;


            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equal weights (5, 5, 5)", test_num);
            asset1 = 4'd5;
            asset2 = 4'd5;
            asset3 = 4'd5;

            #1;


            check_outputs(4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Asset 1 is 100%% (10, 0, 0)", test_num);
            asset1 = 4'd10;
            asset2 = 4'd0;
            asset3 = 4'd0;

            #1;


            check_outputs(4'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Asset 1 is 0%% (0, 5, 5)", test_num);
            asset1 = 4'd0;
            asset2 = 4'd5;
            asset3 = 4'd5;

            #1;


            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max weights (15, 15, 15)", test_num);
            asset1 = 4'd15;
            asset2 = 4'd15;
            asset3 = 4'd15;

            #1;


            check_outputs(4'd5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Fractional result floor (2, 1, 1)", test_num);
            asset1 = 4'd2;
            asset2 = 4'd1;
            asset3 = 4'd1;

            #1;


            check_outputs(4'd7);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sum > 15 (8, 4, 4)", test_num);
            asset1 = 4'd8;
            asset2 = 4'd4;
            asset3 = 4'd4;

            #1;


            check_outputs(4'd7);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum non-zero sum (1, 0, 0)", test_num);
            asset1 = 4'd1;
            asset2 = 4'd0;
            asset3 = 4'd0;

            #1;


            check_outputs(4'd15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("portfolio_normalization Testbench");
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
        input [3:0] expected_normalized_weight;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_normalized_weight === (expected_normalized_weight ^ normalized_weight ^ expected_normalized_weight)) begin
                $display("PASS");
                $display("  Outputs: normalized_weight=%h",
                         normalized_weight);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: normalized_weight=%h",
                         expected_normalized_weight);
                $display("  Got:      normalized_weight=%h",
                         normalized_weight);
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
