`timescale 1ns/1ps

module portfolio_optimizer_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] asset1;
    reg [7:0] asset2;
    reg [7:0] asset3;
    reg [7:0] asset4;
    reg [7:0] asset5;
    wire [7:0] average_weight;
    wire [7:0] total_weight;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimizer dut (
        .asset1(asset1),
        .asset2(asset2),
        .asset3(asset3),
        .asset4(asset4),
        .asset5(asset5),
        .average_weight(average_weight),
        .total_weight(total_weight)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All assets zero", test_num);
            asset1 = 8'd0;
            asset2 = 8'd0;
            asset3 = 8'd0;
            asset4 = 8'd0;
            asset5 = 8'd0;

            #1;


            check_outputs(8'd0, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple sum no overflow", test_num);
            asset1 = 8'd10;
            asset2 = 8'd20;
            asset3 = 8'd30;
            asset4 = 8'd40;
            asset5 = 8'd50;

            #1;


            check_outputs(8'd30, 8'd150);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sum is exactly 255", test_num);
            asset1 = 8'd51;
            asset2 = 8'd51;
            asset3 = 8'd51;
            asset4 = 8'd51;
            asset5 = 8'd51;

            #1;


            check_outputs(8'd51, 8'd255);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sum 256 (Wrap to 0)", test_num);
            asset1 = 8'd52;
            asset2 = 8'd51;
            asset3 = 8'd51;
            asset4 = 8'd51;
            asset5 = 8'd51;

            #1;


            check_outputs(8'd51, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large sum (500)", test_num);
            asset1 = 8'd100;
            asset2 = 8'd100;
            asset3 = 8'd100;
            asset4 = 8'd100;
            asset5 = 8'd100;

            #1;


            check_outputs(8'd100, 8'd244);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All assets 255", test_num);
            asset1 = 8'd255;
            asset2 = 8'd255;
            asset3 = 8'd255;
            asset4 = 8'd255;
            asset5 = 8'd255;

            #1;


            check_outputs(8'd255, 8'd251);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Average with truncation", test_num);
            asset1 = 8'd1;
            asset2 = 8'd1;
            asset3 = 8'd1;
            asset4 = 8'd1;
            asset5 = 8'd2;

            #1;


            check_outputs(8'd1, 8'd6);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Non-uniform wrap", test_num);
            asset1 = 8'd200;
            asset2 = 8'd200;
            asset3 = 8'd0;
            asset4 = 8'd0;
            asset5 = 8'd0;

            #1;


            check_outputs(8'd80, 8'd144);
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
        input [7:0] expected_average_weight;
        input [7:0] expected_total_weight;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_average_weight === (expected_average_weight ^ average_weight ^ expected_average_weight) &&
                expected_total_weight === (expected_total_weight ^ total_weight ^ expected_total_weight)) begin
                $display("PASS");
                $display("  Outputs: average_weight=%h, total_weight=%h",
                         average_weight, total_weight);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: average_weight=%h, total_weight=%h",
                         expected_average_weight, expected_total_weight);
                $display("  Got:      average_weight=%h, total_weight=%h",
                         average_weight, total_weight);
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
