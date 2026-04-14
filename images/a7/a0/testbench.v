`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    reg enable;
    reg [31:0] pc_in;
    reg [31:0] rs_in;
    reg [31:0] rt_in;
    wire [31:0] comp_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .enable(enable),
        .pc_in(pc_in),
        .rs_in(rs_in),
        .rt_in(rt_in),
        .comp_out(comp_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: rs_in == rt_in, check lower 20 bits of data_in");
            enable = 1;
            rs_in = 32'h12345678;
            rt_in = 32'h12345678;
            data_in = 32'hABCDEFFF;
            pc_in = 32'h87654321;
            #1;

            check_outputs(32'h000DEFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: rs_in != rt_in, check output is pc_in");
            enable = 1;
            rs_in = 32'h12345678;
            rt_in = 32'hFFFFFFFF;
            data_in = 32'hABCDEFFF;
            pc_in = 32'h55AA55AA;
            #1;

            check_outputs(32'h55AA55AA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Equal values at zero boundary");
            enable = 1;
            rs_in = 32'h0;
            rt_in = 32'h0;
            data_in = 32'h12345678;
            pc_in = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h00045678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Equal values at max boundary");
            enable = 1;
            rs_in = 32'hFFFFFFFF;
            rt_in = 32'hFFFFFFFF;
            data_in = 32'hFFFFFFFF;
            pc_in = 32'h0;
            #1;

            check_outputs(32'h000FFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Unequal values differing by one bit");
            enable = 1;
            rs_in = 32'h00000001;
            rt_in = 32'h00000000;
            data_in = 32'hFFFFFFFF;
            pc_in = 32'hCAFEBABE;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Equal values with data_in upper bits as 0");
            enable = 1;
            rs_in = 32'hAAAA5555;
            rt_in = 32'hAAAA5555;
            data_in = 32'h00001234;
            pc_in = 32'hDEADBEEF;
            #1;

            check_outputs(32'h00001234);
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
        input [31:0] expected_comp_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_comp_out === (expected_comp_out ^ comp_out ^ expected_comp_out)) begin
                $display("PASS");
                $display("  Outputs: comp_out=%h",
                         comp_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: comp_out=%h",
                         expected_comp_out);
                $display("  Got:      comp_out=%h",
                         comp_out);
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
