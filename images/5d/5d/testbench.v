`timescale 1ns/1ps

module subtractor_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg enable;
    reg reset;
    wire [7:0] diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    subtractor_module dut (
        .a(a),
        .b(b),
        .enable(enable),
        .reset(reset),
        .diff(diff)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Reset Behavior", test_num);

        reset = 1;
        a = 8'hFF;
        b = 8'h01;
        enable = 1;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Simple Subtraction (a > b)", test_num);

        reset = 1;
        #5;
        reset = 0;
        enable = 1;
        a = 8'd50;
        b = 8'd20;

        #1;


        check_outputs(8'd30);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Subtraction with Wrap-around (a < b)", test_num);

        reset = 1;
        #5;
        reset = 0;
        enable = 1;
        a = 8'd10;
        b = 8'd15;


        #1;



        check_outputs(8'hFB);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Subtraction resulting in Zero", test_num);

        reset = 1;
        #5;
        reset = 0;
        enable = 1;
        a = 8'hAA;
        b = 8'hAA;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Subtraction with Maximum Values", test_num);

        reset = 1;
        #5;
        reset = 0;
        enable = 1;
        a = 8'hFF;
        b = 8'h00;

        #1;


        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Reset Override (reset high while enable is high)", test_num);

        reset = 1;
        #5;
        reset = 0;
        enable = 1;
        a = 8'd100;
        b = 8'd20;
        #5;

        reset = 1;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Minimum Values", test_num);

        reset = 1;
        #5;
        reset = 0;
        enable = 1;
        a = 8'h00;
        b = 8'h00;

        #1;


        check_outputs(8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("subtractor_module Testbench");
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
        input [7:0] expected_diff;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_diff === (expected_diff ^ diff ^ expected_diff)) begin
                $display("PASS");
                $display("  Outputs: diff=%h",
                         diff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: diff=%h",
                         expected_diff);
                $display("  Got:      diff=%h",
                         diff);
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
