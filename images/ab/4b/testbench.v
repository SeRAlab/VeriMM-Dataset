`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 32'h0000_0000;
            $display("Test %0d: Zero input", test_num);
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 32'h0000_0001;
            $display("Test %0d: Input 1 (Expected 4)", test_num);
            #1;

            check_outputs(32'h0000_0004);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 32'h0000_0003;
            $display("Test %0d: Input 3 (Expected 12)", test_num);
            #1;

            check_outputs(32'h0000_000C);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 32'hFFFF_FFFF;
            $display("Test %0d: All bits set", test_num);
            #1;

            check_outputs(32'hFFFF_FFFC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 32'h8000_0000;
            $display("Test %0d: Shift out bit 31", test_num);
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 32'h4000_0000;
            $display("Test %0d: Shift out bit 30", test_num);
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 32'h2000_0000;
            $display("Test %0d: Shift bit 29 to bit 31", test_num);
            #1;

            check_outputs(32'h8000_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 32'hAAAA_AAAA;
            $display("Test %0d: Alternating bits A", test_num);
            #1;

            check_outputs(32'hAAAA_AAA8);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 32'h5555_5555;
            $display("Test %0d: Alternating bits 5", test_num);
            #1;

            check_outputs(32'h5555_5554);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 32'h1234_5678;
            $display("Test %0d: Hex pattern 12345678", test_num);
            #1;

            check_outputs(32'h48D1_59E0);
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
        input [31:0] expected_y;
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
