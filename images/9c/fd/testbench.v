`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg msb;
    reg [31:0] mulcand;
    reg sign;
    wire [31:0] pp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .msb(msb),
        .mulcand(mulcand),
        .sign(sign),
        .pp(pp)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Active Case (msb=1, sign=0)", test_num);
            mulcand = 32'hA5A5A5A5;
            msb = 1'b1;
            sign = 1'b0;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: msb Low (msb=0, sign=0)", test_num);
            mulcand = 32'h12345678;
            msb = 1'b0;
            sign = 1'b0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: sign High (msb=1, sign=1)", test_num);
            mulcand = 32'hDEADBEEF;
            msb = 1'b1;
            sign = 1'b1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both False (msb=0, sign=1)", test_num);
            mulcand = 32'hFFFFFFFF;
            msb = 1'b0;
            sign = 1'b1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Active Case All Ones", test_num);
            mulcand = 32'hFFFFFFFF;
            msb = 1'b1;
            sign = 1'b0;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Active Case All Zeros", test_num);
            mulcand = 32'h00000000;
            msb = 1'b1;
            sign = 1'b0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Active", test_num);
            mulcand = 32'h55555555;
            msb = 1'b1;
            sign = 1'b0;
            #1;

            check_outputs(32'h55555555);
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
        input [31:0] expected_pp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pp === (expected_pp ^ pp ^ expected_pp)) begin
                $display("PASS");
                $display("  Outputs: pp=%h",
                         pp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pp=%h",
                         expected_pp);
                $display("  Got:      pp=%h",
                         pp);
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
