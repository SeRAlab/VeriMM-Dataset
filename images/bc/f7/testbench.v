`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] b;
    wire [7:0] bcd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b(b),
        .bcd(bcd)
    );
    task testcase001;

        begin
            test_num = 1;
            b = 4'd0;
            $display("Test %0d: Input b=%d (0x%h)", test_num, b, b);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            b = 4'd5;
            $display("Test %0d: Input b=%d (0x%h)", test_num, b, b);
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            b = 4'd9;
            $display("Test %0d: Input b=%d (0x%h)", test_num, b, b);
            #1;

            check_outputs(8'h09);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            b = 4'd10;
            $display("Test %0d: Input b=%d (0x%h)", test_num, b, b);
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            b = 4'd11;
            $display("Test %0d: Input b=%d (0x%h)", test_num, b, b);
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            b = 4'd13;
            $display("Test %0d: Input b=%d (0x%h)", test_num, b, b);
            #1;

            check_outputs(8'h13);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            b = 4'd15;
            $display("Test %0d: Input b=%d (0x%h)", test_num, b, b);
            #1;

            check_outputs(8'h15);
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
        input [7:0] expected_bcd;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bcd === (expected_bcd ^ bcd ^ expected_bcd)) begin
                $display("PASS");
                $display("  Outputs: bcd=%h",
                         bcd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd=%h",
                         expected_bcd);
                $display("  Got:      bcd=%h",
                         bcd);
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
