`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in_16;
    wire [31:0] data_out_32;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in_16(data_in_16),
        .data_out_32(data_out_32)
    );
    task testcase001;

    begin
        test_num = 1;
        data_in_16 = 16'h0000;
        $display("Test %0d: Sign extension of zero (0x0000)", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        data_in_16 = 16'h0001;
        $display("Test %0d: Sign extension of a small positive value (0x0001)", test_num);
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        data_in_16 = 16'h7FFF;
        $display("Test %0d: Sign extension of the maximum positive 16-bit value (0x7FFF)", test_num);
        #1;

        check_outputs(32'h00007FFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        data_in_16 = 16'hFFFF;
        $display("Test %0d: Sign extension of -1 (0xFFFF)", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        data_in_16 = 16'h8000;
        $display("Test %0d: Sign extension of the minimum negative 16-bit value (0x8000)", test_num);
        #1;

        check_outputs(32'hFFFF8000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        data_in_16 = 16'hA5A5;
        $display("Test %0d: Sign extension of a negative pattern (0xA5A5)", test_num);
        #1;

        check_outputs(32'hFFFFA5A5);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        data_in_16 = 16'h5A5A;
        $display("Test %0d: Sign extension of a positive pattern (0x5A5A)", test_num);
        #1;

        check_outputs(32'h00005A5A);
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
        input [31:0] expected_data_out_32;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out_32 === (expected_data_out_32 ^ data_out_32 ^ expected_data_out_32)) begin
                $display("PASS");
                $display("  Outputs: data_out_32=%h",
                         data_out_32);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out_32=%h",
                         expected_data_out_32);
                $display("  Got:      data_out_32=%h",
                         data_out_32);
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
