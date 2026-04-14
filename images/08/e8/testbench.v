`timescale 1ns/1ps

module PortfolioOptimization_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] return1;
    reg [7:0] return2;
    reg [7:0] return3;
    reg [7:0] weight1;
    reg [7:0] weight2;
    reg [7:0] weight3;
    wire [15:0] portfolio_return;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PortfolioOptimization dut (
        .return1(return1),
        .return2(return2),
        .return3(return3),
        .weight1(weight1),
        .weight2(weight2),
        .weight3(weight3),
        .portfolio_return(portfolio_return)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            weight1 = 8'd0; return1 = 8'd0;
            weight2 = 8'd0; return2 = 8'd0;
            weight3 = 8'd0; return3 = 8'd0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple integer calculation", test_num);

            weight1 = 8'd10; return1 = 8'd5;
            weight2 = 8'd20; return2 = 8'd4;
            weight3 = 8'd30; return3 = 8'd3;
            #1;

            check_outputs(16'd220);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Asset 1 active only", test_num);

            weight1 = 8'd100; return1 = 8'd50;
            weight2 = 8'd0;   return2 = 8'd10;
            weight3 = 8'd20;  return3 = 8'd0;
            #1;

            check_outputs(16'd5000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Asset 2 active only", test_num);

            weight1 = 8'd5;   return1 = 8'd0;
            weight2 = 8'd255; return2 = 8'd10;
            weight3 = 8'd0;   return3 = 8'd255;
            #1;

            check_outputs(16'd2550);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Asset 3 active only", test_num);

            weight1 = 8'd0;   return1 = 8'd255;
            weight2 = 8'd255; return2 = 8'd0;
            weight3 = 8'd128; return3 = 8'd128;
            #1;

            check_outputs(16'd16384);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Weights summing to 100", test_num);

            weight1 = 8'd25;  return1 = 8'd100;
            weight2 = 8'd25;  return2 = 8'd200;
            weight3 = 8'd50;  return3 = 8'd50;
            #1;

            check_outputs(16'd10000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Handling maximum single product", test_num);

            weight1 = 8'd255; return1 = 8'd255;
            weight2 = 8'd0;   return2 = 8'd0;
            weight3 = 8'd0;   return3 = 8'd0;
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 16-bit Overflow Check", test_num);


            weight1 = 8'd255; return1 = 8'd255;
            weight2 = 8'd255; return2 = 8'd255;
            weight3 = 8'd255; return3 = 8'd255;
            #1;

            check_outputs(16'hFA03);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PortfolioOptimization Testbench");
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
        input [15:0] expected_portfolio_return;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_portfolio_return === (expected_portfolio_return ^ portfolio_return ^ expected_portfolio_return)) begin
                $display("PASS");
                $display("  Outputs: portfolio_return=%h",
                         portfolio_return);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: portfolio_return=%h",
                         expected_portfolio_return);
                $display("  Got:      portfolio_return=%h",
                         portfolio_return);
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
