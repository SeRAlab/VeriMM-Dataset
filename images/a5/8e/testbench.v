`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in1;
    reg [31:0] in2;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Division (10 / 2)", test_num);
        in1 = 32'd10;
        in2 = 32'd2;
        #1;

        check_outputs(32'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Dividend smaller than Divisor (5 / 10)", test_num);
        in1 = 32'd5;
        in2 = 32'd10;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Division of Zero (0 / 100)", test_num);
        in1 = 32'd0;
        in2 = 32'd100;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Division by One (Identity) (4294967295 / 1)", test_num);
        in1 = 32'hFFFFFFFF;
        in2 = 32'd1;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Division by Self (500 / 500)", test_num);
        in1 = 32'd500;
        in2 = 32'd500;
        #1;

        check_outputs(32'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Power of Two Division (65536 / 256)", test_num);
        in1 = 32'd65536;
        in2 = 32'd256;
        #1;

        check_outputs(32'd256);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large Result (0xFFFFFFFF / 2)", test_num);
        in1 = 32'hFFFFFFFF;
        in2 = 32'd2;
        #1;

        check_outputs(32'h7FFFFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Division with Remainder (Truncation Check) (7 / 3)", test_num);
        in1 = 32'd7;
        in2 = 32'd3;
        #1;

        check_outputs(32'd2);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large Values (12345678 / 123)", test_num);
        in1 = 32'd12345678;
        in2 = 32'd123;
        #1;

        check_outputs(32'd100371);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary Max Values (0xFFFFFFFF / 0xFFFFFFFF)", test_num);
        in1 = 32'hFFFFFFFF;
        in2 = 32'hFFFFFFFF;
        #1;

        check_outputs(32'd1);
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
