`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] DEC_2BIT;
    wire [3:0] BCD_decade;
    wire [3:0] BCD_unit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DEC_2BIT(DEC_2BIT),
        .BCD_decade(BCD_decade),
        .BCD_unit(BCD_unit)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Input 0 (00000000)", test_num);
        DEC_2BIT = 8'd0;
        #1;

        check_outputs(4'h0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Input 9 (00001001)", test_num);
        DEC_2BIT = 8'd9;
        #1;

        check_outputs(4'h0, 4'h9);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Input 10 (00001010)", test_num);
        DEC_2BIT = 8'd10;
        #1;

        check_outputs(4'h1, 4'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Input 42 (00101010)", test_num);
        DEC_2BIT = 8'd42;
        #1;

        check_outputs(4'h4, 4'h2);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Input 99 (01100011)", test_num);
        DEC_2BIT = 8'd99;
        #1;

        check_outputs(4'h9, 4'h9);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Input 100 (01100100) - Testing Overflow Century", test_num);

        DEC_2BIT = 8'd100;
        #1;

        check_outputs(4'h0, 4'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Input 157 (10011101)", test_num);

        DEC_2BIT = 8'd157;
        #1;

        check_outputs(4'h5, 4'h7);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: Input 255 (11111111) - Max Input", test_num);

        DEC_2BIT = 8'd255;
        #1;

        check_outputs(4'h5, 4'h5);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTestcase %0d: Input 80 (01010000)", test_num);
        DEC_2BIT = 8'd80;
        #1;

        check_outputs(4'h8, 4'h0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTestcase %0d: Input 19 (00010011)", test_num);
        DEC_2BIT = 8'd19;
        #1;

        check_outputs(4'h1, 4'h9);
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
        input [3:0] expected_BCD_decade;
        input [3:0] expected_BCD_unit;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_BCD_decade === (expected_BCD_decade ^ BCD_decade ^ expected_BCD_decade) &&
                expected_BCD_unit === (expected_BCD_unit ^ BCD_unit ^ expected_BCD_unit)) begin
                $display("PASS");
                $display("  Outputs: BCD_decade=%h, BCD_unit=%h",
                         BCD_decade, BCD_unit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BCD_decade=%h, BCD_unit=%h",
                         expected_BCD_decade, expected_BCD_unit);
                $display("  Got:      BCD_decade=%h, BCD_unit=%h",
                         BCD_decade, BCD_unit);
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
