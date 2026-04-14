`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x;
    reg [3:0] y;
    wire [3:0] z;

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
            test_num = test_num + 1;
            x = 4'd0;
            y = 4'd0;
            $display("Test %0d: x=%d, y=%d (Equal, minimum)", test_num, x, y);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            x = 4'd15;
            y = 4'd15;
            $display("Test %0d: x=%d, y=%d (Equal, maximum)", test_num, x, y);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            x = 4'd10;
            y = 4'd5;
            $display("Test %0d: x=%d, y=%d (x > y)", test_num, x, y);
            #1;

            check_outputs(4'd10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            x = 4'd3;
            y = 4'd12;
            $display("Test %0d: x=%d, y=%d (y > x)", test_num, x, y);
            #1;

            check_outputs(4'd12);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            x = 4'd15;
            y = 4'd0;
            $display("Test %0d: x=%d, y=%d (x is max, y is min)", test_num, x, y);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            x = 4'd0;
            y = 4'd15;
            $display("Test %0d: x=%d, y=%d (y is max, x is min)", test_num, x, y);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            x = 4'd7;
            y = 4'd8;
            $display("Test %0d: x=%d, y=%d (Adjacent values, y > x)", test_num, x, y);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            x = 4'd8;
            y = 4'd7;
            $display("Test %0d: x=%d, y=%d (Adjacent values, x > y)", test_num, x, y);
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            x = 4'b1010;
            y = 4'b0110;
            $display("Test %0d: x=%b, y=%b (Bit pattern check)", test_num, x, y);
            #1;

            check_outputs(4'd10);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            x = 4'd1;
            y = 4'd2;
            $display("Test %0d: x=%d, y=%d (Simple small values)", test_num, x, y);
            #1;

            check_outputs(4'd2);
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
        input [3:0] expected_z;
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
