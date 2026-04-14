`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg en;
    reg [1:0] sel;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .en(en),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: en=0, sel=00 - All bits should be 1");
            en = 1'b0;
            sel = 2'b00;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: en=0, sel=11 - All bits should be 1");
            en = 1'b0;
            sel = 2'b11;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: en=1, sel=00 - Bit 0 should be 0");
            en = 1'b1;
            sel = 2'b00;
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: en=1, sel=01 - Bit 1 should be 0");
            en = 1'b1;
            sel = 2'b01;
            #1;

            check_outputs(16'hFFFD);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: en=1, sel=10 - Bit 2 should be 0");
            en = 1'b1;
            sel = 2'b10;
            #1;

            check_outputs(16'hFFFB);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: en=1, sel=11 - Bit 3 should be 0");
            en = 1'b1;
            sel = 2'b11;
            #1;

            check_outputs(16'hFFF7);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: en high-to-low transition");
            en = 1'b1;
            sel = 2'b10;
            #10;
            en = 1'b0;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: en low-to-high transition");
            en = 1'b0;
            sel = 2'b01;
            #10;
            en = 1'b1;
            #1;

            check_outputs(16'hFFFD);
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
