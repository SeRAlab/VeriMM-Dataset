`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] B1;
    wire [19:0] bcdout1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B1(B1),
        .bcdout1(bcdout1)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Zero value", test_num);
            B1 = 16'd0;
            #1;

            check_outputs(20'h00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Single digit boundary", test_num);
            B1 = 16'd9;
            #1;

            check_outputs(20'h00009);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Two digit boundary (10)", test_num);
            B1 = 16'd10;
            #1;

            check_outputs(20'h00010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Common 8-bit maximum", test_num);
            B1 = 16'd255;
            #1;

            check_outputs(20'h00255);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Power of two (1024)", test_num);
            B1 = 16'd1024;
            #1;

            check_outputs(20'h01024);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Four digit boundary (9999)", test_num);
            B1 = 16'd9999;
            #1;

            check_outputs(20'h09999);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Five digit value (12345)", test_num);
            B1 = 16'd12345;
            #1;

            check_outputs(20'h12345);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Maximum 16-bit value (65535)", test_num);
            B1 = 16'd65535;
            #1;

            check_outputs(20'h65535);
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
        input [19:0] expected_bcdout1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bcdout1 === (expected_bcdout1 ^ bcdout1 ^ expected_bcdout1)) begin
                $display("PASS");
                $display("  Outputs: bcdout1=%h",
                         bcdout1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcdout1=%h",
                         expected_bcdout1);
                $display("  Got:      bcdout1=%h",
                         bcdout1);
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
