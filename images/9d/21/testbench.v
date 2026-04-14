`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] x1;
    reg [9:0] x2;
    reg [9:0] x3;
    wire [9:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            x1 = 10'd0;
            x2 = 10'd0;
            x3 = 10'd0;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple Addition", test_num);
            x1 = 10'd10;
            x2 = 10'd20;
            x3 = 10'd30;
            #1;

            check_outputs(10'd60);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum value without overflow", test_num);
            x1 = 10'd500;
            x2 = 10'd500;
            x3 = 10'd23;
            #1;

            check_outputs(10'd1023);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single overflow boundary", test_num);
            x1 = 10'd1023;
            x2 = 10'd1;
            x3 = 10'd0;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Double overflow boundary", test_num);
            x1 = 10'd1023;
            x2 = 10'd1023;
            x3 = 10'd0;
            #1;

            check_outputs(10'd1022);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Triple maximum values (Maximum overflow)", test_num);
            x1 = 10'd1023;
            x2 = 10'd1023;
            x3 = 10'd1023;
            #1;

            check_outputs(10'd1021);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Balanced inputs", test_num);
            x1 = 10'd341;
            x2 = 10'd341;
            x3 = 10'd341;
            #1;

            check_outputs(10'd1023);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Power of two sum", test_num);
            x1 = 10'd256;
            x2 = 10'd256;
            x3 = 10'd512;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random values", test_num);
            x1 = 10'd123;
            x2 = 10'd456;
            x3 = 10'd78;
            #1;

            check_outputs(10'd657);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating bits", test_num);
            x1 = 10'b1010101010;
            x2 = 10'b0101010101;
            x3 = 10'b0000000001;
            #1;

            check_outputs(10'd0);
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
        input [9:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
