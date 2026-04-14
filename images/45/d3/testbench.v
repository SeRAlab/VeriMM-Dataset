`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    wire [7:0] y;

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
            $display("\nTest %0d: All zeros", test_num);
            a = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest %0d: Least Significant Bit (Shift out)", test_num);
            a = 8'h01;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest %0d: Most Significant Bit", test_num);
            a = 8'h80;
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest %0d: All ones", test_num);
            a = 8'hFF;
            #1;

            check_outputs(8'h7F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest %0d: Alternating pattern 10101010", test_num);
            a = 8'hAA;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest %0d: Alternating pattern 01010101", test_num);
            a = 8'h55;
            #1;

            check_outputs(8'h2A);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest %0d: Single bit internal shift", test_num);
            a = 8'h10;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest %0d: Edge case high nibble", test_num);
            a = 8'hF0;
            #1;

            check_outputs(8'h78);
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
        input [7:0] expected_y;
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
