`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    wire [7:0] out_hi;
    wire [7:0] out_lo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Input 16'h0000");
        in = 16'h0000;
        #1;

        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Input 16'hFFFF");
        in = 16'hFFFF;
        #1;

        check_outputs(8'hFF, 8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Input 16'hA55A");
        in = 16'hA55A;
        #1;

        check_outputs(8'hA5, 8'h5A);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Input 16'h1234");
        in = 16'h1234;
        #1;

        check_outputs(8'h12, 8'h34);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Input 16'h00FF");
        in = 16'h00FF;
        #1;

        check_outputs(8'h00, 8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Input 16'hFF00");
        in = 16'hFF00;
        #1;

        check_outputs(8'hFF, 8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Input 16'h8000");
        in = 16'h8000;
        #1;

        check_outputs(8'h80, 8'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Input 16'h0001");
        in = 16'h0001;
        #1;

        check_outputs(8'h00, 8'h01);
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
        input [7:0] expected_out_hi;
        input [7:0] expected_out_lo;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_hi === (expected_out_hi ^ out_hi ^ expected_out_hi) &&
                expected_out_lo === (expected_out_lo ^ out_lo ^ expected_out_lo)) begin
                $display("PASS");
                $display("  Outputs: out_hi=%h, out_lo=%h",
                         out_hi, out_lo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_hi=%h, out_lo=%h",
                         expected_out_hi, expected_out_lo);
                $display("  Got:      out_hi=%h, out_lo=%h",
                         out_hi, out_lo);
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
