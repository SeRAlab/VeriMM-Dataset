`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [27:0] l;
    reg [27:0] r;
    wire [47:0] outpc2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .l(l),
        .r(r),
        .outpc2(outpc2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            l = 28'h0000000;
            r = 28'h0000000;
            #1;

            check_outputs(48'h000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            l = 28'hFFFFFFF;
            r = 28'hFFFFFFF;
            #1;

            check_outputs(48'hFFFFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            l = 28'hFFFFFFF;
            r = 28'h0000000;
            #1;

            check_outputs(48'hFFFFFF000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            l = 28'h0000000;
            r = 28'hFFFFFFF;
            #1;

            check_outputs(48'h000000FFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            l = 28'h0004000;
            r = 28'h0000000;
            #1;

            check_outputs(48'h800000000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            l = 28'h0000000;
            r = 28'h1000000;
            #1;

            check_outputs(48'h000000000001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            l = 28'h0000000;
            r = 28'h8000000;
            #1;

            check_outputs(48'h000000000002);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            l = 28'h8000000;
            r = 28'h0000000;
            #1;

            check_outputs(48'h000800000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            l = 28'h0004001;
            r = 28'h1000001;
            #1;

            check_outputs(48'h810000000101);
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
        input [47:0] expected_outpc2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_outpc2 === (expected_outpc2 ^ outpc2 ^ expected_outpc2)) begin
                $display("PASS");
                $display("  Outputs: outpc2=%h",
                         outpc2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outpc2=%h",
                         expected_outpc2);
                $display("  Got:      outpc2=%h",
                         outpc2);
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
