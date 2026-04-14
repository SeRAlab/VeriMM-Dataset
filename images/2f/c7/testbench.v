`timescale 1ns/1ps

module portfolio_optimization_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] return1;
    reg [7:0] return2;
    reg [7:0] return3;
    reg [7:0] return4;
    reg [7:0] return5;
    reg [7:0] weight1;
    reg [7:0] weight2;
    reg [7:0] weight3;
    reg [7:0] weight4;
    reg [7:0] weight5;
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
        .return4(return4),
        .return5(return5),
        .weight1(weight1),
        .weight2(weight2),
        .weight3(weight3),
        .weight4(weight4),
        .weight5(weight5),
        .total_weighted_return(total_weighted_return)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            return1 = 8'h00; return2 = 8'h00; return3 = 8'h00; return4 = 8'h00; return5 = 8'h00;
            weight1 = 8'h00; weight2 = 8'h00; weight3 = 8'h00; weight4 = 8'h00; weight5 = 8'h00;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Unit Weights", test_num);

            return1 = 8'd10; return2 = 8'd20; return3 = 8'd30; return4 = 8'd40; return5 = 8'd50;
            weight1 = 8'd1;  weight2 = 8'd1;  weight3 = 8'd1;  weight4 = 8'd1;  weight5 = 8'd1;
            #1;

            check_outputs(16'h0096);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Single Asset Portfolio", test_num);

            return1 = 8'd50;  return2 = 8'd0;  return3 = 8'd0;  return4 = 8'd0;  return5 = 8'd0;
            weight1 = 8'd100; weight2 = 8'd0;  weight3 = 8'd0;  weight4 = 8'd0;  weight5 = 8'd0;
            #1;

            check_outputs(16'h1388);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Mixed Values", test_num);

            return1 = 8'd1;  return2 = 8'd2;  return3 = 8'd3;  return4 = 8'd4;  return5 = 8'd5;
            weight1 = 8'd2;  weight2 = 8'd4;  weight3 = 8'd6;  weight4 = 8'd8;  weight5 = 8'd10;
            #1;

            check_outputs(16'h006E);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Large Values near 16-bit limit", test_num);

            return1 = 8'hFF; return2 = 8'h00; return3 = 8'h00; return4 = 8'h00; return5 = 8'h00;
            weight1 = 8'hFF; weight2 = 8'h00; weight3 = 8'h00; weight4 = 8'h00; weight5 = 8'h00;
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Maximum Values (Truncated to 16-bit)", test_num);



            return1 = 8'hFF; return2 = 8'hFF; return3 = 8'hFF; return4 = 8'hFF; return5 = 8'hFF;
            weight1 = 8'hFF; weight2 = 8'hFF; weight3 = 8'hFF; weight4 = 8'hFF; weight5 = 8'hFF;
            #1;

            check_outputs(16'hF605);
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
