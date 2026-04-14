`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] c;
    reg [31:0] d;
    wire [31:0] min;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .min(min)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Minimum is 'a'", test_num);
            a = 32'd10;
            b = 32'd20;
            c = 32'd30;
            d = 32'd40;
            #1;

            check_outputs(32'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Minimum is 'b'", test_num);
            a = 32'hFFFF_FFFF;
            b = 32'h0000_0005;
            c = 32'hFFFF_0000;
            d = 32'h0000_FFFF;
            #1;

            check_outputs(32'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Minimum is 'c'", test_num);
            a = 32'd1000;
            b = 32'd500;
            c = 32'd1;
            d = 32'd250;
            #1;

            check_outputs(32'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Minimum is 'd'", test_num);
            a = 32'hABCDEF01;
            b = 32'hBCDEF012;
            c = 32'hCDEF0123;
            d = 32'h0000_0000;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: All inputs equal", test_num);
            a = 32'h5555_AAAA;
            b = 32'h5555_AAAA;
            c = 32'h5555_AAAA;
            d = 32'h5555_AAAA;
            #1;

            check_outputs(32'h5555_AAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Duplicate minimums (a and c)", test_num);
            a = 32'd42;
            b = 32'd99;
            c = 32'd42;
            d = 32'd105;
            #1;

            check_outputs(32'd42);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: High range values", test_num);
            a = 32'hFFFF_FFFF;
            b = 32'hFFFF_FFFE;
            c = 32'hFFFF_FFFF;
            d = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'hFFFF_FFFE);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Small differences", test_num);
            a = 32'd1000001;
            b = 32'd1000002;
            c = 32'd1000003;
            d = 32'd1000000;
            #1;

            check_outputs(32'd1000000);
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
        input [31:0] expected_min;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_min === (expected_min ^ min ^ expected_min)) begin
                $display("PASS");
                $display("  Outputs: min=%h",
                         min);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: min=%h",
                         expected_min);
                $display("  Got:      min=%h",
                         min);
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
