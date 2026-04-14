`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [3:0] OUT0;
    wire [3:0] OUT1;
    wire [3:0] OUT2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .OUT0(OUT0),
        .OUT1(OUT1),
        .OUT2(OUT2)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input bit 0 (8'h01)", test_num);
        in = 8'b0000_0001;
        #1;

        check_outputs(4'd0, 4'd0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input bit 1 (8'h02)", test_num);
        in = 8'b0000_0010;
        #1;

        check_outputs(4'd1, 4'd0, 4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input bit 2 (8'h04)", test_num);
        in = 8'b0000_0100;
        #1;

        check_outputs(4'd0, 4'd1, 4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input bit 3 (8'h08)", test_num);
        in = 8'b0000_1000;
        #1;

        check_outputs(4'd1, 4'd1, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input bit 4 (8'h10)", test_num);
        in = 8'b0001_0000;
        #1;

        check_outputs(4'd0, 4'd0, 4'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input bit 5 (8'h20)", test_num);
        in = 8'b0010_0000;
        #1;

        check_outputs(4'd1, 4'd0, 4'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input bit 6 (8'h40)", test_num);
        in = 8'b0100_0000;
        #1;

        check_outputs(4'd0, 4'd1, 4'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input bit 7 (8'h80)", test_num);
        in = 8'b1000_0000;
        #1;

        check_outputs(4'd1, 4'd1, 4'd1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: No input (8'h00) - Error State", test_num);
        in = 8'b0000_0000;
        #1;

        check_outputs(4'd0, 4'd0, 4'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [3:0] expected_OUT0;
        input [3:0] expected_OUT1;
        input [3:0] expected_OUT2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT0 === (expected_OUT0 ^ OUT0 ^ expected_OUT0) &&
                expected_OUT1 === (expected_OUT1 ^ OUT1 ^ expected_OUT1) &&
                expected_OUT2 === (expected_OUT2 ^ OUT2 ^ expected_OUT2)) begin
                $display("PASS");
                $display("  Outputs: OUT0=%h, OUT1=%h, OUT2=%h",
                         OUT0, OUT1, OUT2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT0=%h, OUT1=%h, OUT2=%h",
                         expected_OUT0, expected_OUT1, expected_OUT2);
                $display("  Got:      OUT0=%h, OUT1=%h, OUT2=%h",
                         OUT0, OUT1, OUT2);
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
