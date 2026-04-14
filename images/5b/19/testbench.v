`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] y;

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
            $display("Testcase 001: Simple addition (1 + 1)");
            a = 32'd1;
            b = 32'd1;
            #1;

            check_outputs(32'd2);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Zero addition (0 + 0)");
            a = 32'd0;
            b = 32'd0;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Adding zero to a number");
            a = 32'hdeadbeef;
            b = 32'h00000000;
            #1;

            check_outputs(32'hdeadbeef);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Maximum value minus one");
            a = 32'hffffffff;
            b = 32'h00000000;
            #1;

            check_outputs(32'hffffffff);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overflow check (wrap around)");
            a = 32'hffffffff;
            b = 32'h00000001;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Bit pattern alternation");
            a = 32'haaaaaaaa;
            b = 32'h55555555;
            #1;

            check_outputs(32'hffffffff);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Large sum check");
            a = 32'h7fffffff;
            b = 32'h7fffffff;
            #1;

            check_outputs(32'hfffffffe);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Arbitrary values");
            a = 32'h12345678;
            b = 32'h87654321;
            #1;

            check_outputs(32'h99999999);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Carry propagation across multiple bits");
            a = 32'h0000ffff;
            b = 32'h00000001;
            #1;

            check_outputs(32'h00010000);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Hex calculation check");
            a = 32'h11111111;
            b = 32'h22222222;
            #1;

            check_outputs(32'h33333333);
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
