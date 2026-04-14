`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] dataA;
    reg [31:0] dataB;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dataA(dataA),
        .dataB(dataB),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %03d: Multiply by Zero (0 * 0)", test_num);
        dataA = 32'h00000000;
        dataB = 32'h00000000;
        #10;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %03d: Multiply by Zero (A * 0)", test_num);
        dataA = 32'h12345678;
        dataB = 32'h00000000;
        #10;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %03d: Multiply by One (A * 1)", test_num);
        dataA = 32'hA5A5A5A5;
        dataB = 32'h00000001;
        #10;
        #1;

        check_outputs(32'hA5A5A5A5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %03d: Simple Multiplication (5 * 10)", test_num);
        dataA = 32'd5;
        dataB = 32'd10;
        #10;
        #1;

        check_outputs(32'd50);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %03d: Medium values (0xFFFF * 0x10)", test_num);
        dataA = 32'h0000FFFF;
        dataB = 32'h00000010;
        #10;
        #1;

        check_outputs(32'h000FFFF0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %03d: Max 16-bit squared", test_num);
        dataA = 32'h0000FFFF;
        dataB = 32'h0000FFFF;
        #10;
        #1;

        check_outputs(32'hFFFE0001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %03d: Truncation check (Power of 2 overflow)", test_num);
        dataA = 32'h00010000;
        dataB = 32'h00010000;
        #10;

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %03d: Max uint32 * Max uint32 (Truncated)", test_num);
        dataA = 32'hFFFFFFFF;
        dataB = 32'hFFFFFFFF;
        #10;


        #1;



        check_outputs(32'h00000001);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %03d: Typical large numbers", test_num);
        dataA = 32'h12345678;
        dataB = 32'h00000002;
        #10;
        #1;

        check_outputs(32'h2468ACF0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %03d: Max uint32 * 2 (Truncated)", test_num);
        dataA = 32'hFFFFFFFF;
        dataB = 32'h00000002;
        #10;

        #1;


        check_outputs(32'hFFFFFFFE);
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
