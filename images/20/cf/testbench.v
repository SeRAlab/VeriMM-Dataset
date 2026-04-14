`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] asset1;
    reg [4:0] asset2;
    reg [4:0] asset3;
    wire [4:0] normalized_weight;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .asset1(asset1),
        .asset2(asset2),
        .asset3(asset3),
        .normalized_weight(normalized_weight)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Single asset dominance (Asset 1)", test_num);
            asset1 = 5'd31; asset2 = 5'd0; asset3 = 5'd0;

            #1;


            check_outputs(5'd31);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: All assets equal", test_num);
            asset1 = 5'd10; asset2 = 5'd10; asset3 = 5'd10;

            #1;


            check_outputs(5'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Asset 2 is most significant", test_num);
            asset1 = 5'd5; asset2 = 5'd20; asset3 = 5'd5;

            #1;


            check_outputs(5'd20);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Asset 3 is most significant with power-of-2 sum", test_num);
            asset1 = 5'd2; asset2 = 5'd2; asset3 = 5'd4;

            #1;


            check_outputs(5'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Two assets tied for max", test_num);
            asset1 = 5'd15; asset2 = 5'd15; asset3 = 5'd0;

            #1;


            check_outputs(5'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Smallest possible non-zero values", test_num);
            asset1 = 5'd1; asset2 = 5'd1; asset3 = 5'd1;

            #1;


            check_outputs(5'd10);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Maximum possible sum (all inputs maxed)", test_num);
            asset1 = 5'd31; asset2 = 5'd31; asset3 = 5'd31;

            #1;


            check_outputs(5'd10);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Diverse weights", test_num);
            asset1 = 5'd12; asset2 = 5'd3; asset3 = 5'd9;

            #1;


            check_outputs(5'd15);
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
        input [4:0] expected_normalized_weight;
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
