`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] out_max;
    wire [31:0] out_min;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .out_max(out_max),
        .out_min(out_min)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a < b", test_num);
            a = 32'd10;
            b = 32'd20;
            #1;

            check_outputs(32'd20, 32'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a > b", test_num);
            a = 32'd500;
            b = 32'd100;
            #1;

            check_outputs(32'd500, 32'd100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a == b", test_num);
            a = 32'hABCDE123;
            b = 32'hABCDE123;
            #1;

            check_outputs(32'hABCDE123, 32'hABCDE123);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero and Max Unsigned", test_num);
            a = 32'h00000000;
            b = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: One bit difference at MSB", test_num);
            a = 32'h7FFFFFFF;
            b = 32'h80000000;
            #1;

            check_outputs(32'h80000000, 32'h7FFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: One bit difference at LSB", test_num);
            a = 32'h00000001;
            b = 32'h00000000;
            #1;

            check_outputs(32'h00000001, 32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bit patterns", test_num);
            a = 32'hAAAAAAAA;
            b = 32'h55555555;
            #1;

            check_outputs(32'hAAAAAAAA, 32'h55555555);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large values", test_num);
            a = 32'hFFFFFFFE;
            b = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFE);
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
        input [31:0] expected_out_max;
        input [31:0] expected_out_min;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_max === (expected_out_max ^ out_max ^ expected_out_max) &&
                expected_out_min === (expected_out_min ^ out_min ^ expected_out_min)) begin
                $display("PASS");
                $display("  Outputs: out_max=%h, out_min=%h",
                         out_max, out_min);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_max=%h, out_min=%h",
                         expected_out_max, expected_out_min);
                $display("  Got:      out_max=%h, out_min=%h",
                         out_max, out_min);
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
