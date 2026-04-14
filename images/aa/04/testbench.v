`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg ctrl;
    wire [31:0] and_out;
    wire [31:0] or_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ctrl(ctrl),
        .and_out(and_out),
        .or_out(or_out)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 32'hAAAAAAAA;
            b = 32'h55555555;
            ctrl = 1'b1;


            $display("Testcase %0d: ctrl high, complementary inputs", test_num);
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 32'hAAAAAAAA;
            b = 32'h55555555;
            ctrl = 1'b0;


            $display("Testcase %0d: ctrl low, complementary inputs", test_num);
            #1;

            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 32'hFFFFFFFF;
            b = 32'hFFFFFFFF;
            ctrl = 1'b1;


            $display("Testcase %0d: ctrl high, all-ones inputs", test_num);
            #1;

            check_outputs(32'hFFFFFFFF, 32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 32'h00000000;
            b = 32'h00000000;
            ctrl = 1'b0;


            $display("Testcase %0d: ctrl low, all-zeros inputs", test_num);
            #1;

            check_outputs(32'hFFFFFFFF, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 32'h12345678;
            b = 32'h87654321;
            ctrl = 1'b1;


            $display("Testcase %0d: ctrl high, mixed patterns", test_num);
            #1;

            check_outputs(32'h02244220, 32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 32'h12345678;
            b = 32'h87654321;
            ctrl = 1'b0;


            $display("Testcase %0d: ctrl low, mixed patterns", test_num);
            #1;

            check_outputs(32'hFFFFFFFF, 32'h97755779);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 32'hF0F0F0F0;
            b = 32'hCCCC0000;
            ctrl = 1'b1;


            $display("Testcase %0d: ctrl high, boundary test", test_num);
            #1;

            check_outputs(32'hC0C00000, 32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 32'hF0F0F0F0;
            b = 32'hCCCC0000;
            ctrl = 1'b0;


            $display("Testcase %0d: ctrl low, boundary test", test_num);
            #1;

            check_outputs(32'hFFFFFFFF, 32'hFCFCF0F0);
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
        input [31:0] expected_and_out;
        input [31:0] expected_or_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_and_out === (expected_and_out ^ and_out ^ expected_and_out) &&
                expected_or_out === (expected_or_out ^ or_out ^ expected_or_out)) begin
                $display("PASS");
                $display("  Outputs: and_out=%h, or_out=%h",
                         and_out, or_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: and_out=%h, or_out=%h",
                         expected_and_out, expected_or_out);
                $display("  Got:      and_out=%h, or_out=%h",
                         and_out, or_out);
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
