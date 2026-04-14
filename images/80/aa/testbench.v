`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] dat1;
    reg [31:0] dat2;
    reg port_select;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dat1(dat1),
        .dat2(dat2),
        .port_select(port_select),
        .data_out(data_out)
    );
    task testcase001;

        begin
            $display("Test Case 001: Select dat1 (port_select = 0)");
            dat1 = 32'hAAAAAAAA;
            dat2 = 32'h55555555;
            port_select = 1'b0;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Select dat2 (port_select = 1)");
            dat1 = 32'hAAAAAAAA;
            dat2 = 32'h55555555;
            port_select = 1'b1;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: All ones on dat1, select dat1");
            dat1 = 32'hFFFFFFFF;
            dat2 = 32'h00000000;
            port_select = 1'b0;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: All ones on dat1, select dat2");
            dat1 = 32'hFFFFFFFF;
            dat2 = 32'h00000000;
            port_select = 1'b1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Random pattern 1, select dat1");
            dat1 = 32'h12345678;
            dat2 = 32'h87654321;
            port_select = 1'b0;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Random pattern 2, select dat2");
            dat1 = 32'hDEADBEEF;
            dat2 = 32'hCAFEBABE;
            port_select = 1'b1;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Walking bit pattern, select dat1");
            dat1 = 32'h00000001;
            dat2 = 32'h80000000;
            port_select = 1'b0;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Walking bit pattern, select dat2");
            dat1 = 32'h00000001;
            dat2 = 32'h80000000;
            port_select = 1'b1;
            #1;

            check_outputs(32'h80000000);
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
        input [31:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
