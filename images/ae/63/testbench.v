`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] num;
    wire [15:0] i;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .num(num),
        .i(i)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input num = 0 (Expect 0 bits set)", test_num);
            num = 5'd0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input num = 1 (Expect 1 bit set)", test_num);
            num = 5'd1;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input num = 2 (Expect 2 bits set)", test_num);
            num = 5'd2;
            #1;

            check_outputs(16'h0003);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input num = 4 (Expect 4 bits set)", test_num);
            num = 5'd4;
            #1;

            check_outputs(16'h000F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input num = 8 (Expect 8 bits set)", test_num);
            num = 5'd8;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input num = 12 (Expect 12 bits set)", test_num);
            num = 5'd12;
            #1;

            check_outputs(16'h0FFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input num = 14 (Expect 14 bits set)", test_num);
            num = 5'd14;
            #1;

            check_outputs(16'h3FFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input num = 15 (Boundary of defined range, expect 15 bits set)", test_num);
            num = 5'd15;
            #1;

            check_outputs(16'h7FFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input num = 16 (Exceeds range, expect full set of 16 bits)", test_num);
            num = 5'd16;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input num = 31 (Exceeds range, expect full set of 16 bits)", test_num);
            num = 5'd31;
            #1;

            check_outputs(16'hFFFF);
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
        input [15:0] expected_i;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_i === (expected_i ^ i ^ expected_i)) begin
                $display("PASS");
                $display("  Outputs: i=%h",
                         i);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: i=%h",
                         expected_i);
                $display("  Got:      i=%h",
                         i);
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
