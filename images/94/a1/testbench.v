`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] i;
    reg sel;
    wire [15:0] x;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i(i),
        .sel(sel),
        .x(x),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: sel=0, i=0xFFFF", test_num);
            sel = 1'b0;
            i = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: sel=1, i=0xAAAA", test_num);
            sel = 1'b1;
            i = 16'hAAAA;
            #1;

            check_outputs(16'h0000, 16'hAAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: sel=0, i=0x5555", test_num);
            sel = 1'b0;
            i = 16'h5555;
            #1;

            check_outputs(16'h5555, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: sel=1, i=0x0000", test_num);
            sel = 1'b1;
            i = 16'h0000;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: sel=0, i=0x1234", test_num);
            sel = 1'b0;
            i = 16'h1234;
            #1;

            check_outputs(16'h1234, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: sel=1, i=0xFFFF", test_num);
            sel = 1'b1;
            i = 16'hFFFF;
            #1;

            check_outputs(16'h0000, 16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: sel=0, i=0x0000", test_num);
            sel = 1'b0;
            i = 16'h0000;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: sel=1, i=0x1234", test_num);
            sel = 1'b1;
            i = 16'h1234;
            #1;

            check_outputs(16'h0000, 16'h1234);
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
        input [15:0] expected_x;
        input [15:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_x === (expected_x ^ x ^ expected_x) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: x=%h, y=%h",
                         x, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x=%h, y=%h",
                         expected_x, expected_y);
                $display("  Got:      x=%h, y=%h",
                         x, y);
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
