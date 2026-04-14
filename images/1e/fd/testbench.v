`timescale 1ns/1ps

module portfolio_optimization_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] return1;
    reg [7:0] return2;
    reg [7:0] return3;
    reg [7:0] weight1;
    reg [7:0] weight2;
    reg [7:0] weight3;
    wire [15:0] total_weighted_return;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    portfolio_optimization dut (
        .return1(return1),
        .return2(return2),
        .return3(return3),
        .weight1(weight1),
        .weight2(weight2),
        .weight3(weight3),
        .total_weighted_return(total_weighted_return)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: All Zeros");
            return1 = 8'd0; return2 = 8'd0; return3 = 8'd0;
            weight1 = 8'd0; weight2 = 8'd0; weight3 = 8'd0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Single Asset Contribution");
            return1 = 8'd100; return2 = 8'd0;   return3 = 8'd0;
            weight1 = 8'd50;  weight2 = 8'd200; weight3 = 8'd10;

            #1;


            check_outputs(16'd5000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Uniform Returns and Weights");
            return1 = 8'd10; weight1 = 8'd20;
            return2 = 8'd10; weight2 = 8'd20;
            return3 = 8'd10; weight3 = 8'd20;

            #1;


            check_outputs(16'd600);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Mid-range Calculation");
            return1 = 8'd120; weight1 = 8'd40;
            return2 = 8'd80;  weight2 = 8'd100;
            return3 = 8'd200; weight3 = 8'd30;

            #1;


            check_outputs(16'd18800);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Large values within 16-bit range");
            return1 = 8'd255; weight1 = 8'd80;
            return2 = 8'd255; weight2 = 8'd80;
            return3 = 8'd255; weight3 = 8'd80;

            #1;


            check_outputs(16'd61200);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Small Weights High Returns");
            return1 = 8'd255; weight1 = 8'd2;
            return2 = 8'd255; weight2 = 8'd4;
            return3 = 8'd255; weight3 = 8'd8;

            #1;


            check_outputs(16'd3570);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Maximum overflow behavior (Modulo 2^16)");
            return1 = 8'd255; weight1 = 8'd255;
            return2 = 8'd255; weight2 = 8'd255;
            return3 = 8'd255; weight3 = 8'd255;



            #1;




            check_outputs(16'd64003);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("portfolio_optimization Testbench");
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
        input [15:0] expected_total_weighted_return;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_total_weighted_return === (expected_total_weighted_return ^ total_weighted_return ^ expected_total_weighted_return)) begin
                $display("PASS");
                $display("  Outputs: total_weighted_return=%h",
                         total_weighted_return);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: total_weighted_return=%h",
                         expected_total_weighted_return);
                $display("  Got:      total_weighted_return=%h",
                         total_weighted_return);
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
