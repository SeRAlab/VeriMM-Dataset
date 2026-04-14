`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 8'd0;
            b = 8'd0;
            $display("Test %0d: Zero Addition (0 + 0)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 8'd15;
            b = 8'd32;
            $display("Test %0d: Basic Addition (15 + 32)", test_num);
            #1;

            check_outputs(8'd47);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 8'hFF;
            b = 8'h00;
            $display("Test %0d: Identity Addition (255 + 0)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 8'd127;
            b = 8'd128;
            $display("Test %0d: Boundary Addition (127 + 128)", test_num);
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 8'hFF;
            b = 8'h01;
            $display("Test %0d: Single Bit Overflow (255 + 1)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 8'hFF;
            b = 8'hFF;
            $display("Test %0d: Double Max Overflow (255 + 255)", test_num);
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 8'd200;
            b = 8'd100;
            $display("Test %0d: Mid-range Overflow (200 + 100)", test_num);
            #1;

            check_outputs(8'd44);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 8'hAA;
            b = 8'h55;
            $display("Test %0d: Bit Pattern Addition (0xAA + 0x55)", test_num);
            #1;

            check_outputs(8'hFF);
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
