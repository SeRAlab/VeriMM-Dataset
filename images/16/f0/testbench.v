`timescale 1ns/1ps

module portfolio_optimization_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] return1;
    reg [3:0] return2;
    reg [3:0] return3;
    reg [3:0] weight1;
    reg [3:0] weight2;
    reg [3:0] weight3;
    wire [7:0] expected_return;

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
        .expected_return(expected_return)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: All Zeros");
        return1 = 4'd0; weight1 = 4'd0;
        return2 = 4'd0; weight2 = 4'd0;
        return3 = 4'd0; weight3 = 4'd0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Maximum Values");
        return1 = 4'd15; weight1 = 4'd15;
        return2 = 4'd15; weight2 = 4'd15;
        return3 = 4'd15; weight3 = 4'd15;
        #1;

        check_outputs(8'hA8);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Mid-range Values");
        return1 = 4'd8; weight1 = 4'd8;
        return2 = 4'd8; weight2 = 4'd8;
        return3 = 4'd8; weight3 = 4'd8;
        #1;

        check_outputs(8'h30);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Minimum weights/returns for non-zero output");
        return1 = 4'd2; weight1 = 4'd2;
        return2 = 4'd0; weight2 = 4'd0;
        return3 = 4'd0; weight3 = 4'd0;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Small values resulting in zero (truncation check)");
        return1 = 4'd1; weight1 = 4'd1;
        return2 = 4'd1; weight2 = 4'd1;
        return3 = 4'd1; weight3 = 4'd1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Single asset at maximum");
        return1 = 4'd15; weight1 = 4'd15;
        return2 = 4'd0; weight2 = 4'd0;
        return3 = 4'd0; weight3 = 4'd0;
        #1;

        check_outputs(8'h38);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Mixed asset values");
        return1 = 4'd2; weight1 = 4'd3;
        return2 = 4'd4; weight2 = 4'd5;
        return3 = 4'd6; weight3 = 4'd7;
        #1;

        check_outputs(8'h11);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: High values near overflow");
        return1 = 4'd15; weight1 = 4'd11;
        return2 = 4'd15; weight2 = 4'd11;
        return3 = 4'd15; weight3 = 4'd11;
        #1;

        check_outputs(8'h7B);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: Two assets active");
        return1 = 4'd15; weight1 = 4'd15;
        return2 = 4'd15; weight2 = 4'd15;
        return3 = 4'd0;  weight3 = 4'd0;
        #1;

        check_outputs(8'h70);
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
        testcase008();
        testcase009();
        
        
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
        input [7:0] expected_expected_return;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_expected_return === (expected_expected_return ^ expected_return ^ expected_expected_return)) begin
                $display("PASS");
                $display("  Outputs: expected_return=%h",
                         expected_return);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: expected_return=%h",
                         expected_expected_return);
                $display("  Got:      expected_return=%h",
                         expected_return);
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
