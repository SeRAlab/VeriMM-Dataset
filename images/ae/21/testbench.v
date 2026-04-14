`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] mode;
    reg [3:0] x;
    reg [3:0] y;
    wire [3:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mode(mode),
        .x(x),
        .y(y),
        .z(z)
    );
    task testcase001;

        begin
            test_num = 1;
            mode = 2'd0;
            x = 4'b1010;
            y = 4'b1100;
            $display("Test %0d: Mode 0 (AND) - x=%b, y=%b", test_num, x, y);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            mode = 2'd0;
            x = 4'b1111;
            y = 4'b0101;
            $display("Test %0d: Mode 0 (AND) - x=%b, y=%b", test_num, x, y);
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            mode = 2'd1;
            x = 4'b1010;
            y = 4'b0101;
            $display("Test %0d: Mode 1 (OR) - x=%b, y=%b", test_num, x, y);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            mode = 2'd1;
            x = 4'b1100;
            y = 4'b0000;
            $display("Test %0d: Mode 1 (OR) - x=%b, y=%b", test_num, x, y);
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            mode = 2'd2;
            x = 4'b1111;
            y = 4'b1111;
            $display("Test %0d: Mode 2 (XOR) - x=%b, y=%b", test_num, x, y);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            mode = 2'd2;
            x = 4'b1010;
            y = 4'b0101;
            $display("Test %0d: Mode 2 (XOR) - x=%b, y=%b", test_num, x, y);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            mode = 2'd2;
            x = 4'b1100;
            y = 4'b1010;
            $display("Test %0d: Mode 2 (XOR) - x=%b, y=%b", test_num, x, y);
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            mode = 2'd0;
            x = 4'b0000;
            y = 4'b1111;
            $display("Test %0d: Mode 0 (AND) - x=%b, y=%b", test_num, x, y);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            mode = 2'd1;
            x = 4'b0011;
            y = 4'b0110;
            $display("Test %0d: Mode 1 (OR) - x=%b, y=%b", test_num, x, y);
            #1;

            check_outputs(4'b0111);
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
