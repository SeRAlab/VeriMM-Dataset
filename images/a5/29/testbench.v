`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg sel;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );
    task testcase001;

        begin
            a = 4'hA;
            b = 4'hB;
            sel = 1'b0;
            $display("Running Testcase 001: sel=0, a=A, b=B");
            #1;

            check_outputs(8'hAB);
        end
        endtask

    task testcase002;

        begin
            a = 4'hA;
            b = 4'hB;
            sel = 1'b1;
            $display("Running Testcase 002: sel=1, a=A, b=B");
            #1;

            check_outputs(8'hBA);
        end
        endtask

    task testcase003;

        begin
            a = 4'hF;
            b = 4'h0;
            sel = 1'b0;
            $display("Running Testcase 003: sel=0, a=F, b=0");
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase004;

        begin
            a = 4'hF;
            b = 4'h0;
            sel = 1'b1;
            $display("Running Testcase 004: sel=1, a=F, b=0");
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase005;

        begin
            a = 4'h5;
            b = 4'hC;
            sel = 1'b0;
            $display("Running Testcase 005: sel=0, a=5, b=C");
            #1;

            check_outputs(8'h5C);
        end
        endtask

    task testcase006;

        begin
            a = 4'h5;
            b = 4'hC;
            sel = 1'b1;
            $display("Running Testcase 006: sel=1, a=5, b=C");
            #1;

            check_outputs(8'hC5);
        end
        endtask

    task testcase007;

        begin
            a = 4'h0;
            b = 4'h0;
            sel = 1'b0;
            $display("Running Testcase 007: All Zeros, sel=0");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            a = 4'hF;
            b = 4'hF;
            sel = 1'b1;
            $display("Running Testcase 008: All Ones, sel=1");
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
