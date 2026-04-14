`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire [4:0] diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .diff(diff)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 4'd15;
        b = 4'd0;
        #10;
        #1;

        check_outputs(5'h0F);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 4'd10;
        b = 4'd10;
        #10;
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 4'd12;
        b = 4'd4;
        #10;
        #1;

        check_outputs(5'h08);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 4'd5;
        b = 4'd10;
        #10;
        #1;

        check_outputs(5'h1B);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 4'd0;
        b = 4'd15;
        #10;
        #1;

        check_outputs(5'h11);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 4'd7;
        b = 4'd8;
        #10;
        #1;

        check_outputs(5'h1F);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 4'd15;
        b = 4'd15;
        #10;
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 4'd8;
        b = 4'd4;
        #10;
        #1;

        check_outputs(5'h04);
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
        input [4:0] expected_diff;
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
