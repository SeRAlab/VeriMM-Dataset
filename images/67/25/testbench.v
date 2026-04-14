`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] data_in;
    reg [7:0] poly;
    wire [63:0] crc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .poly(poly),
        .crc_out(crc_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros Input", test_num);
            data_in = 64'h0;
            poly = 8'h07;
            #1;

            check_outputs(crc8_ref(data_in, poly));
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Bit Set", test_num);
            data_in = 64'h0000_0000_0000_0001;
            poly = 8'h07;
            #1;

            check_outputs(crc8_ref(data_in, poly));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones Input", test_num);
            data_in = 64'hFFFF_FFFF_FFFF_FFFF;
            poly = 8'h07;
            #1;

            check_outputs(crc8_ref(data_in, poly));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternative Polynomial (0x31)", test_num);
            data_in = 64'hA5A5_A5A5_A5A5_A5A5;
            poly = 8'h31;
            #1;

            check_outputs(crc8_ref(data_in, poly));
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sequential Byte Pattern", test_num);
            data_in = 64'h0102_0304_0506_0708;
            poly = 8'h07;
            #1;

            check_outputs(crc8_ref(data_in, poly));
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random Data Input", test_num);
            data_in = 64'h1234_5678_9ABC_DEF0;
            poly = 8'h07;
            #1;

            check_outputs(crc8_ref(data_in, poly));
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
        input [63:0] expected_crc_out;
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
