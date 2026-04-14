`timescale 1ns/1ps

module PortfolioOptimizer_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] return1;
    reg [15:0] return2;
    reg [15:0] return3;
    reg [7:0] weight1;
    reg [7:0] weight2;
    reg [7:0] weight3;
    wire [31:0] total_return;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PortfolioOptimizer dut (
        .return1(return1),
        .return2(return2),
        .return3(return3),
        .weight1(weight1),
        .weight2(weight2),
        .weight3(weight3),
        .total_return(total_return)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            return1 = 16'd0; return2 = 16'd0; return3 = 16'd0;
            weight1 = 8'd0;  weight2 = 8'd0;  weight3 = 8'd0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Asset Return", test_num);
            return1 = 16'd1000; return2 = 16'd0; return3 = 16'd0;
            weight1 = 8'd50;   weight2 = 8'd0; weight3 = 8'd0;

            #1;


            check_outputs(32'h0000C350);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Unit Weights", test_num);
            return1 = 16'd10; return2 = 16'd20; return3 = 16'd30;
            weight1 = 8'd1;  weight2 = 8'd1;  weight3 = 8'd1;

            #1;


            check_outputs(32'h0000003C);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Weights", test_num);
            return1 = 16'h0001; return2 = 16'h0002; return3 = 16'h0003;
            weight1 = 8'hFF;   weight2 = 8'hFF;   weight3 = 8'hFF;

            #1;


            check_outputs(32'h000005FA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Returns with Balanced Weights", test_num);
            return1 = 16'hFFFF; return2 = 16'hFFFF; return3 = 16'hFFFF;
            weight1 = 8'd100;  weight2 = 8'd100;  weight3 = 8'd55;

            #1;


            check_outputs(32'h00FF3E01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Possible Output", test_num);
            return1 = 16'hFFFF; return2 = 16'hFFFF; return3 = 16'hFFFF;
            weight1 = 8'hFF;   weight2 = 8'hFF;   weight3 = 8'hFF;

            #1;


            check_outputs(32'h02FD1103);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Realistic Portfolio Mix", test_num);
            return1 = 16'd500;
            return2 = 16'd1200;
            return3 = 16'd300;
            weight1 = 8'd40;
            weight2 = 8'd40;
            weight3 = 8'd20;

            #1;


            check_outputs(32'h00012108);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Prime Numbers Mix", test_num);
            return1 = 16'd17;  return2 = 16'd31;  return3 = 16'd47;
            weight1 = 8'd11;  weight2 = 8'd13;  weight3 = 8'd19;

            #1;


            check_outputs(32'h000005CB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("PortfolioOptimizer Testbench");
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
        input [31:0] expected_total_return;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_total_return === (expected_total_return ^ total_return ^ expected_total_return)) begin
                $display("PASS");
                $display("  Outputs: total_return=%h",
                         total_return);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: total_return=%h",
                         expected_total_return);
                $display("  Got:      total_return=%h",
                         total_return);
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
