`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x;
    reg [7:0] y;
    wire [7:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .z(z)
    );
    task testcase001;

        begin
            test_num = 1;
            x = 8'h00;
            y = 8'h00;
            $display("Test %0d: All Zeros (x=%h, y=%h)", test_num, x, y);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            x = 8'hFF;
            y = 8'hFF;
            $display("Test %0d: All Ones (x=%h, y=%h)", test_num, x, y);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            x = 8'h10;
            y = 8'h20;
            $display("Test %0d: x < y (x=%h, y=%h)", test_num, x, y);
            #1;

            check_outputs(8'h20);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            x = 8'h50;
            y = 8'h30;
            $display("Test %0d: x > y (x=%h, y=%h)", test_num, x, y);
            #1;

            check_outputs(8'h50);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            x = 8'h7F;
            y = 8'h80;
            $display("Test %0d: Signed Boundary x < y (x=%h, y=%h)", test_num, x, y);
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            x = 8'h80;
            y = 8'h7F;
            $display("Test %0d: Signed Boundary x > y (x=%h, y=%h)", test_num, x, y);
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            x = 8'hAA;
            y = 8'h55;
            $display("Test %0d: Alternating Bits Pattern (x=%h, y=%h)", test_num, x, y);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            x = 8'hDE;
            y = 8'hAD;
            $display("Test %0d: Random Values (x=%h, y=%h)", test_num, x, y);
            #1;

            check_outputs(8'hDE);
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
        input [7:0] expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: z=%h",
                         z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z=%h",
                         expected_z);
                $display("  Got:      z=%h",
                         z);
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
