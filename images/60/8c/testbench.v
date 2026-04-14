`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    wire [3:0] bcd_high;
    wire [3:0] bcd_low;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .bcd_high(bcd_high),
        .bcd_low(bcd_low)
    );
    task testcase001;

    begin
        test_num = 1;
        in = 4'd0;
        $display("Test %0d: Input in = %d", test_num, in);
        #1;

        check_outputs(4'd0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in = 4'd1;
        $display("Test %0d: Input in = %d", test_num, in);
        #1;

        check_outputs(4'd0, 4'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in = 4'd2;
        $display("Test %0d: Input in = %d", test_num, in);
        #1;

        check_outputs(4'd0, 4'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in = 4'd3;
        $display("Test %0d: Input in = %d", test_num, in);
        #1;

        check_outputs(4'd0, 4'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in = 4'd4;
        $display("Test %0d: Input in = %d", test_num, in);
        #1;

        check_outputs(4'd0, 4'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in = 4'd5;
        $display("Test %0d: Input in = %d", test_num, in);
        #1;

        check_outputs(4'd0, 4'd5);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in = 4'd6;
        $display("Test %0d: Input in = %d", test_num, in);
        #1;

        check_outputs(4'd0, 4'd6);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in = 4'd7;
        $display("Test %0d: Input in = %d", test_num, in);
        #1;

        check_outputs(4'd0, 4'd7);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        in = 4'd8;
        $display("Test %0d: Input in = %d", test_num, in);
        #1;

        check_outputs(4'd0, 4'd8);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        in = 4'd9;
        $display("Test %0d: Input in = %d", test_num, in);
        #1;

        check_outputs(4'd0, 4'd9);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        in = 4'd10;
        $display("Test %0d: Input in = %d", test_num, in);
        #1;

        check_outputs(4'd1, 4'd0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        in = 4'd11;
        $display("Test %0d: Input in = %d", test_num, in);
        #1;

        check_outputs(4'd1, 4'd1);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        in = 4'd12;
        $display("Test %0d: Input in = %d", test_num, in);
        #1;

        check_outputs(4'd1, 4'd2);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        in = 4'd13;
        $display("Test %0d: Input in = %d", test_num, in);
        #1;

        check_outputs(4'd1, 4'd3);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        in = 4'd14;
        $display("Test %0d: Input in = %d", test_num, in);
        #1;

        check_outputs(4'd1, 4'd4);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        in = 4'd15;
        $display("Test %0d: Input in = %d", test_num, in);
        #1;

        check_outputs(4'd1, 4'd5);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [3:0] expected_bcd_high;
        input [3:0] expected_bcd_low;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bcd_high === (expected_bcd_high ^ bcd_high ^ expected_bcd_high) &&
                expected_bcd_low === (expected_bcd_low ^ bcd_low ^ expected_bcd_low)) begin
                $display("PASS");
                $display("  Outputs: bcd_high=%h, bcd_low=%h",
                         bcd_high, bcd_low);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd_high=%h, bcd_low=%h",
                         expected_bcd_high, expected_bcd_low);
                $display("  Got:      bcd_high=%h, bcd_low=%h",
                         bcd_high, bcd_low);
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
