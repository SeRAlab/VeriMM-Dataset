`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] src0;
    wire [4:0] most;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .src0(src0),
        .most(most)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All zeros", test_num);
            src0 = 32'h00000000;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Least Significant Bit only", test_num);
            src0 = 32'h00000001;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Most Significant Bit only", test_num);
            src0 = 32'h80000000;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Power of 2 (bit 1)", test_num);
            src0 = 32'h00000002;
            #1;

            check_outputs(5'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Power of 2 (bit 15)", test_num);
            src0 = 32'h00008000;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: All bits set", test_num);
            src0 = 32'hFFFFFFFF;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Multiple bits set (MSB at 4)", test_num);
            src0 = 32'h0000001C;
            #1;

            check_outputs(5'd4);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Multiple bits set (MSB at 30)", test_num);
            src0 = 32'h4000FFFF;
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Single bit (bit 23)", test_num);
            src0 = 32'h00800000;
            #1;

            check_outputs(5'd23);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Alternating bits (MSB at 24)", test_num);
            src0 = 32'h01010101;
            #1;

            check_outputs(5'd24);
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
        input [4:0] expected_most;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_most === (expected_most ^ most ^ expected_most)) begin
                $display("PASS");
                $display("  Outputs: most=%h",
                         most);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: most=%h",
                         expected_most);
                $display("  Got:      most=%h",
                         most);
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
