`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [39:0] fast_sig;
    wire [39:0] fast_sig_buf;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .fast_sig(fast_sig),
        .fast_sig_buf(fast_sig_buf)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            fast_sig = 40'h00_0000_0000;
            #1;

            check_outputs(40'h00_0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            fast_sig = 40'hFF_FFFF_FFFF;
            #1;

            check_outputs(40'hFF_FFFF_FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checkerboard Pattern A", test_num);
            fast_sig = 40'hAA_AAAA_AAAA;
            #1;

            check_outputs(40'hAA_AAAA_AAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Checkerboard Pattern 5", test_num);
            fast_sig = 40'h55_5555_5555;
            #1;

            check_outputs(40'h55_5555_5555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Hex Pattern", test_num);
            fast_sig = 40'h12_3456_789A;
            #1;

            check_outputs(40'h12_3456_789A);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Bit (LSB)", test_num);
            fast_sig = 40'h00_0000_0001;
            #1;

            check_outputs(40'h00_0000_0001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Bit (MSB)", test_num);
            fast_sig = 40'h80_0000_0000;
            #1;

            check_outputs(40'h80_0000_0000);
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
        input [39:0] expected_fast_sig_buf;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_fast_sig_buf === (expected_fast_sig_buf ^ fast_sig_buf ^ expected_fast_sig_buf)) begin
                $display("PASS");
                $display("  Outputs: fast_sig_buf=%h",
                         fast_sig_buf);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fast_sig_buf=%h",
                         expected_fast_sig_buf);
                $display("  Got:      fast_sig_buf=%h",
                         fast_sig_buf);
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
