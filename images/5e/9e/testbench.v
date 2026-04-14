`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg mult;
    wire [15:0] high;
    wire [15:0] low;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .mult(mult),
        .high(high),
        .low(low)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 16'sd5;
        B = 16'sd10;
        mult = 1'b1;
        #1;

        check_outputs(16'h0000, 16'h0032);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = -16'sd5;
        B = 16'sd10;
        mult = 1'b1;
        #1;

        check_outputs(16'hFFFF, 16'hFFCE);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = -16'sd5;
        B = -16'sd10;
        mult = 1'b1;
        #1;

        check_outputs(16'h0000, 16'h0032);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 16'sd0;
        B = 16'sd1234;
        mult = 1'b1;
        #1;

        check_outputs(16'h0000, 16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 16'sh7FFF;
        B = 16'sh7FFF;
        mult = 1'b1;
        #1;

        check_outputs(16'h3FFF, 16'h0001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 16'sh8000;
        B = 16'sh8000;
        mult = 1'b1;
        #1;

        check_outputs(16'h4000, 16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 16'sh8000;
        B = 16'sh7FFF;
        mult = 1'b1;
        #1;

        check_outputs(16'hC000, 16'h8000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 16'sd10;
        B = 16'sd10;
        mult = 1'b0;
        #1;

        check_outputs(16'h0000, 16'h0000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = -16'sd1;
        B = -16'sd1;
        mult = 1'b1;
        #1;

        check_outputs(16'h0000, 16'h0001);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = -16'sd1;
        B = 16'sd1;
        mult = 1'b1;
        #1;

        check_outputs(16'hFFFF, 16'hFFFF);
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
        input [15:0] expected_high;
        input [15:0] expected_low;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_high === (expected_high ^ high ^ expected_high) &&
                expected_low === (expected_low ^ low ^ expected_low)) begin
                $display("PASS");
                $display("  Outputs: high=%h, low=%h",
                         high, low);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: high=%h, low=%h",
                         expected_high, expected_low);
                $display("  Got:      high=%h, low=%h",
                         high, low);
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
