`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ldr_data;
    reg [31:0] result;
    reg select;
    wire [31:0] out_load_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ldr_data(ldr_data),
        .result(result),
        .select(select),
        .out_load_data(out_load_data)
    );
    task testcase001;

        begin
            $display("Testcase 001: select=0, verify result is passed to output");
            test_num = test_num + 1;
            select = 1'b0;
            ldr_data = 32'hAAAA_AAAA;
            result   = 32'h5555_5555;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: select=1, verify ldr_data is passed to output");
            test_num = test_num + 1;
            select = 1'b1;
            ldr_data = 32'hAAAA_AAAA;
            result   = 32'h5555_5555;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: select=0, all zeros result, all ones ldr_data");
            test_num = test_num + 1;
            select = 1'b0;
            ldr_data = 32'hFFFF_FFFF;
            result   = 32'h0000_0000;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: select=1, all zeros result, all ones ldr_data");
            test_num = test_num + 1;
            select = 1'b1;
            ldr_data = 32'hFFFF_FFFF;
            result   = 32'h0000_0000;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: select=0, arbitrary hex values");
            test_num = test_num + 1;
            select = 1'b0;
            ldr_data = 32'h1234_5678;
            result   = 32'h8765_4321;
            #1;

            check_outputs(32'h8765_4321);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: select=1, arbitrary hex values");
            test_num = test_num + 1;
            select = 1'b1;
            ldr_data = 32'hDEAD_BEEF;
            result   = 32'hCAFE_BABE;
            #1;

            check_outputs(32'hDEAD_BEEF);
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
        input [31:0] expected_out_load_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_load_data === (expected_out_load_data ^ out_load_data ^ expected_out_load_data)) begin
                $display("PASS");
                $display("  Outputs: out_load_data=%h",
                         out_load_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_load_data=%h",
                         expected_out_load_data);
                $display("  Got:      out_load_data=%h",
                         out_load_data);
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
