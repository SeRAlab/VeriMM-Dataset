`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    wire [7:0] w;
    wire x;
    wire [7:0] y;
    wire [7:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .w(w),
        .x(x),
        .y(y),
        .z(z)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: Verifying initial constant outputs...");
            test_num = test_num + 1;


            #1;



            check_outputs(8'd255, 1'b1, 8'd64, 8'd128);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Verifying output stability after 10ns...");
            test_num = test_num + 1;
            #10;

            #1;


            check_outputs(8'd255, 1'b1, 8'd64, 8'd128);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Verifying output stability after 100ns...");
            test_num = test_num + 1;
            #90;

            #1;


            check_outputs(8'd255, 1'b1, 8'd64, 8'd128);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Bit-pattern verification...");
            test_num = test_num + 1;
            #5;

            #1;


            check_outputs(8'hFF, 1'b1, 8'h40, 8'h80);
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
        input [7:0] expected_w;
        input expected_x;
        input [7:0] expected_y;
        input [7:0] expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_w === (expected_w ^ w ^ expected_w) &&
                expected_x === (expected_x ^ x ^ expected_x) &&
                expected_y === (expected_y ^ y ^ expected_y) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: w=%h, x=%b, y=%h, z=%h",
                         w, x, y, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: w=%h, x=%b, y=%h, z=%h",
                         expected_w, expected_x, expected_y, expected_z);
                $display("  Got:      w=%h, x=%b, y=%h, z=%h",
                         w, x, y, z);
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
