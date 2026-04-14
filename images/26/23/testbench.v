`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] asset1_return;
    reg [7:0] asset2_return;
    reg [7:0] asset3_return;
    wire [7:0] weight1;
    wire [7:0] weight2;
    wire [7:0] weight3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .asset1_return(asset1_return),
        .asset2_return(asset2_return),
        .asset3_return(asset3_return),
        .weight1(weight1),
        .weight2(weight2),
        .weight3(weight3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Asset 1 is clearly optimal", test_num);
            asset1_return = 8'd100;
            asset2_return = 8'd50;
            asset3_return = 8'd25;
            #1;

            check_outputs(8'h01, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Asset 2 is clearly optimal", test_num);
            asset1_return = 8'd10;
            asset2_return = 8'd250;
            asset3_return = 8'd200;
            #1;

            check_outputs(8'h00, 8'h01, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Asset 3 is clearly optimal", test_num);
            asset1_return = 8'd0;
            asset2_return = 8'd0;
            asset3_return = 8'd1;
            #1;

            check_outputs(8'h00, 8'h00, 8'h01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Tie between A1 and A2 (Priority A1)", test_num);
            asset1_return = 8'd75;
            asset2_return = 8'd75;
            asset3_return = 8'd30;

            #1;


            check_outputs(8'h01, 8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Tie between A2 and A3 (Priority A2)", test_num);
            asset1_return = 8'd40;
            asset2_return = 8'd90;
            asset3_return = 8'd90;
            #1;

            check_outputs(8'h00, 8'h01, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All returns equal (Priority A1)", test_num);
            asset1_return = 8'd128;
            asset2_return = 8'd128;
            asset3_return = 8'd128;
            #1;

            check_outputs(8'h01, 8'h00, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum return values", test_num);
            asset1_return = 8'hFF;
            asset2_return = 8'hFE;
            asset3_return = 8'hFD;
            #1;

            check_outputs(8'h01, 8'h00, 8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All returns zero", test_num);
            asset1_return = 8'd0;
            asset2_return = 8'd0;
            asset3_return = 8'd0;

            #1;


            check_outputs(8'h01, 8'h00, 8'h00);
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
        input [7:0] expected_weight1;
        input [7:0] expected_weight2;
        input [7:0] expected_weight3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_weight1 === (expected_weight1 ^ weight1 ^ expected_weight1) &&
                expected_weight2 === (expected_weight2 ^ weight2 ^ expected_weight2) &&
                expected_weight3 === (expected_weight3 ^ weight3 ^ expected_weight3)) begin
                $display("PASS");
                $display("  Outputs: weight1=%h, weight2=%h, weight3=%h",
                         weight1, weight2, weight3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: weight1=%h, weight2=%h, weight3=%h",
                         expected_weight1, expected_weight2, expected_weight3);
                $display("  Got:      weight1=%h, weight2=%h, weight3=%h",
                         weight1, weight2, weight3);
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
