`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in1;
    wire [31:0] out1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .out1(out1)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Initial value (100)");
            in1 = 32'd100;
            #10;
            #1;

            check_outputs(32'd100);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Input smaller value (50), should maintain 100");
            in1 = 32'd50;
            #10;
            #1;

            check_outputs(32'd100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Input larger value (250), should update to 250");
            in1 = 32'd250;
            #10;
            #1;

            check_outputs(32'd250);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Input same value (250), should stay at 250");
            in1 = 32'd250;
            #10;
            #1;

            check_outputs(32'd250);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Input maximum 32-bit unsigned value");
            in1 = 32'hFFFFFFFF;
            #10;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Input 0, should stay at FFFFFFFF");
            in1 = 32'd0;
            #10;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Input mid-range value (2^31), should stay at FFFFFFFF");
            in1 = 32'h7FFFFFFF;
            #10;
            #1;

            check_outputs(32'hFFFFFFFF);
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
        input [31:0] expected_out1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out1 === (expected_out1 ^ out1 ^ expected_out1)) begin
                $display("PASS");
                $display("  Outputs: out1=%h",
                         out1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out1=%h",
                         expected_out1);
                $display("  Got:      out1=%h",
                         out1);
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
