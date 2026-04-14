`timescale 1ns/1ps

module PortfolioOptimization_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] return1;
    reg [3:0] return2;
    reg [3:0] return3;
    reg [3:0] weight1;
    reg [3:0] weight2;
    reg [3:0] weight3;
    wire [5:0] total_return;

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
        .total_return(total_return)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All inputs zero", test_num);
        return1 = 4'd0; weight1 = 4'd0;
        return2 = 4'd0; weight2 = 4'd0;
        return3 = 4'd0; weight3 = 4'd0;

        #1;


        check_outputs(6'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Single asset at maximum return and max weight", test_num);
        return1 = 4'd15; weight1 = 4'd15;
        return2 = 4'd0;  weight2 = 4'd0;
        return3 = 4'd0;  weight3 = 4'd0;

        #1;


        check_outputs(6'd14);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Evenly distributed weights and returns", test_num);
        return1 = 4'd10; weight1 = 4'd8;
        return2 = 4'd10; weight2 = 4'd8;
        return3 = 4'd0;  weight3 = 4'd0;

        #1;


        check_outputs(6'd10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mixed portfolio with various weights", test_num);
        return1 = 4'd5;  weight1 = 4'd10;
        return2 = 4'd12; weight2 = 4'd4;
        return3 = 4'd15; weight3 = 4'd2;

        #1;


        check_outputs(6'd8);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum possible values", test_num);
        return1 = 4'd15; weight1 = 4'd15;
        return2 = 4'd15; weight2 = 4'd15;
        return3 = 4'd15; weight3 = 4'd15;

        #1;


        check_outputs(6'd42);
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
        input [5:0] expected_total_return;
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
