`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] asset1;
    reg [4:0] asset2;
    reg [4:0] asset3;
    wire [4:0] optimal_asset;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .asset1(asset1),
        .asset2(asset2),
        .asset3(asset3),
        .optimal_asset(optimal_asset)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: asset1 is the highest return.", test_num);
            asset1 = 5'd25; asset2 = 5'd15; asset3 = 5'd10;
            #1;

            check_outputs(5'd25);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: asset2 is the highest return.", test_num);
            asset1 = 5'd8; asset2 = 5'd30; asset3 = 5'd22;
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: asset3 is the highest return.", test_num);
            asset1 = 5'd12; asset2 = 5'd18; asset3 = 5'd31;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Tie between asset1 and asset2 (both highest).", test_num);
            asset1 = 5'd20; asset2 = 5'd20; asset3 = 5'd5;
            #1;

            check_outputs(5'd20);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Tie between asset2 and asset3 (both highest).", test_num);
            asset1 = 5'd3; asset2 = 5'd15; asset3 = 5'd15;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Tie between asset1 and asset3 (both highest).", test_num);
            asset1 = 5'd28; asset2 = 5'd14; asset3 = 5'd28;
            #1;

            check_outputs(5'd28);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All assets have the same return.", test_num);
            asset1 = 5'd11; asset2 = 5'd11; asset3 = 5'd11;
            #1;

            check_outputs(5'd11);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All returns are zero.", test_num);
            asset1 = 5'd0; asset2 = 5'd0; asset3 = 5'd0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary values (max 5-bit value).", test_num);
            asset1 = 5'd31; asset2 = 5'd0; asset3 = 5'd16;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small variation check.", test_num);
            asset1 = 5'd1; asset2 = 5'd2; asset3 = 5'd3;
            #1;

            check_outputs(5'd3);
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
        input [4:0] expected_optimal_asset;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_optimal_asset === (expected_optimal_asset ^ optimal_asset ^ expected_optimal_asset)) begin
                $display("PASS");
                $display("  Outputs: optimal_asset=%h",
                         optimal_asset);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: optimal_asset=%h",
                         expected_optimal_asset);
                $display("  Got:      optimal_asset=%h",
                         optimal_asset);
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
