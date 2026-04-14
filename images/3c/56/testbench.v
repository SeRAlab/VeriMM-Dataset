`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] asset1_return;
    reg [3:0] asset2_return;
    reg [3:0] asset3_return;
    wire [2:0] optimal_allocation;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .asset1_return(asset1_return),
        .asset2_return(asset2_return),
        .asset3_return(asset3_return),
        .optimal_allocation(optimal_allocation)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Asset 1 is max", test_num);
            asset1_return = 4'd10;
            asset2_return = 4'd5;
            asset3_return = 4'd2;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Asset 2 is max", test_num);
            asset1_return = 4'd3;
            asset2_return = 4'd12;
            asset3_return = 4'd4;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Asset 3 is max", test_num);
            asset1_return = 4'd1;
            asset2_return = 4'd1;
            asset3_return = 4'd15;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Tie between Asset 1 and 2", test_num);
            asset1_return = 4'd8;
            asset2_return = 4'd8;
            asset3_return = 4'd2;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Tie between Asset 2 and 3", test_num);
            asset1_return = 4'd0;
            asset2_return = 4'd7;
            asset3_return = 4'd7;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Tie between Asset 1 and 3", test_num);
            asset1_return = 4'd9;
            asset2_return = 4'd4;
            asset3_return = 4'd9;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All assets equal (Max 15)", test_num);
            asset1_return = 4'd15;
            asset2_return = 4'd15;
            asset3_return = 4'd15;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All assets equal (Min 0)", test_num);
            asset1_return = 4'd0;
            asset2_return = 4'd0;
            asset3_return = 4'd0;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Asset 1 slightly higher", test_num);
            asset1_return = 4'd2;
            asset2_return = 4'd1;
            asset3_return = 4'd1;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary values mixed", test_num);
            asset1_return = 4'd14;
            asset2_return = 4'd15;
            asset3_return = 4'd14;
            #1;

            check_outputs(3'b010);
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
        input [2:0] expected_optimal_allocation;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_optimal_allocation === (expected_optimal_allocation ^ optimal_allocation ^ expected_optimal_allocation)) begin
                $display("PASS");
                $display("  Outputs: optimal_allocation=%h",
                         optimal_allocation);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: optimal_allocation=%h",
                         expected_optimal_allocation);
                $display("  Got:      optimal_allocation=%h",
                         optimal_allocation);
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
