`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [3:0] lineNumber;
    reg [4:0] spriteNumber;
    wire [19:0] address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .lineNumber(lineNumber),
        .spriteNumber(spriteNumber),
        .address(address)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Minimum values (Sprite 0, Line 0)", test_num);
        spriteNumber = 5'd0;
        lineNumber = 4'd0;

        clk = 0; #5; clk = 1; #5;
        #1;

        check_outputs(20'h00000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sprite 0, Max Line 15", test_num);
        spriteNumber = 5'd0;
        lineNumber = 4'd15;
        clk = 0; #5; clk = 1; #5;
        #1;

        check_outputs(20'h0000F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sprite 1, Line 0", test_num);
        spriteNumber = 5'd1;
        lineNumber = 4'd0;
        clk = 0; #5; clk = 1; #5;
        #1;

        check_outputs(20'h00010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sprite 10, Line 5", test_num);
        spriteNumber = 5'd10;
        lineNumber = 4'd5;
        clk = 0; #5; clk = 1; #5;
        #1;

        check_outputs(20'd165);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sprite 20, Line 10", test_num);
        spriteNumber = 5'd20;
        lineNumber = 4'd10;
        clk = 0; #5; clk = 1; #5;
        #1;

        check_outputs(20'd330);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Sprite 31, Maximum Line 15", test_num);
        spriteNumber = 5'd31;
        lineNumber = 4'd15;
        clk = 0; #5; clk = 1; #5;
        #1;

        check_outputs(20'd511);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sprite 15, Line 8", test_num);
        spriteNumber = 5'd15;
        lineNumber = 4'd8;
        clk = 0; #5; clk = 1; #5;
        #1;

        check_outputs(20'd248);
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
        input [19:0] expected_address;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_address === (expected_address ^ address ^ expected_address)) begin
                $display("PASS");
                $display("  Outputs: address=%h",
                         address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: address=%h",
                         expected_address);
                $display("  Got:      address=%h",
                         address);
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
