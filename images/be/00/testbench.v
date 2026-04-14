`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] binary;
    reg [3:0] select;
    wire [3:0] Hundreds;
    wire [3:0] Ones;
    wire [3:0] Tens;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary(binary),
        .select(select),
        .Hundreds(Hundreds),
        .Ones(Ones),
        .Tens(Tens)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 0", test_num);
        binary = 8'd0;
        select = 4'd0;
        #1;

        check_outputs(4'd0, 4'd0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 9 (Single Digit)", test_num);
        binary = 8'd9;
        select = 4'd0;
        #1;

        check_outputs(4'd0, 4'd9, 4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 10 (Two Digit Boundary)", test_num);
        binary = 8'd10;
        select = 4'd0;
        #1;

        check_outputs(4'd0, 4'd0, 4'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 42", test_num);
        binary = 8'd42;
        select = 4'd0;
        #1;

        check_outputs(4'd0, 4'd2, 4'd4);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 99 (Max Two Digit)", test_num);
        binary = 8'd99;
        select = 4'd0;
        #1;

        check_outputs(4'd0, 4'd9, 4'd9);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 100 (Three Digit Boundary)", test_num);
        binary = 8'd100;
        select = 4'd0;
        #1;

        check_outputs(4'd1, 4'd0, 4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 123", test_num);
        binary = 8'd123;
        select = 4'd0;
        #1;

        check_outputs(4'd1, 4'd3, 4'd2);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 158", test_num);
        binary = 8'd158;
        select = 4'd0;
        #1;

        check_outputs(4'd1, 4'd8, 4'd5);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 200", test_num);
        binary = 8'd200;
        select = 4'd0;
        #1;

        check_outputs(4'd2, 4'd0, 4'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 255 (Max Value)", test_num);
        binary = 8'd255;
        select = 4'd0;
        #1;

        check_outputs(4'd2, 4'd5, 4'd5);
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
        testcase010();
        
        
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
        input [3:0] expected_Hundreds;
        input [3:0] expected_Ones;
        input [3:0] expected_Tens;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Hundreds === (expected_Hundreds ^ Hundreds ^ expected_Hundreds) &&
                expected_Ones === (expected_Ones ^ Ones ^ expected_Ones) &&
                expected_Tens === (expected_Tens ^ Tens ^ expected_Tens)) begin
                $display("PASS");
                $display("  Outputs: Hundreds=%h, Ones=%h, Tens=%h",
                         Hundreds, Ones, Tens);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Hundreds=%h, Ones=%h, Tens=%h",
                         expected_Hundreds, expected_Ones, expected_Tens);
                $display("  Got:      Hundreds=%h, Ones=%h, Tens=%h",
                         Hundreds, Ones, Tens);
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
