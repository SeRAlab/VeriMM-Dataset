`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [10:0] di;
    wire [4:0] crc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .di(di),
        .crc_out(crc_out)
    );
    task testcase001;

    begin
        test_num = 1;
        di = 11'h000;
        #1;

        check_outputs(5'h1F);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        di = 11'h7FF;
        #1;

        check_outputs(5'h19);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        di = 11'h400;
        #1;

        check_outputs(5'h1A);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        di = 11'h001;
        #1;

        check_outputs(5'h1E);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        di = 11'h555;
        #1;

        check_outputs(5'h1B);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        di = 11'h2AA;
        #1;

        check_outputs(5'h1D);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        di = 11'h0F0;
        #1;

        check_outputs(5'h0C);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        di = 11'h321;
        #1;

        check_outputs(5'h02);
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
        input [4:0] expected_crc_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h",
                         crc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h",
                         expected_crc_out);
                $display("  Got:      crc_out=%h",
                         crc_out);
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
