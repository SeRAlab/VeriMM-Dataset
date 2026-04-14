`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] Bus_data;
    reg [31:0] Mdata_in;
    reg Mem_read_enable;
    wire [31:0] MDMux_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Bus_data(Bus_data),
        .Mdata_in(Mdata_in),
        .Mem_read_enable(Mem_read_enable),
        .MDMux_out(MDMux_out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Select Bus_data (Mem_read_enable = 0)");
            Bus_data = 32'hAAAA_BBBB;
            Mdata_in = 32'h1234_5678;
            Mem_read_enable = 1'b0;
            #1;

            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Select Mdata_in (Mem_read_enable = 1)");
            Bus_data = 32'hAAAA_BBBB;
            Mdata_in = 32'h1234_5678;
            Mem_read_enable = 1'b1;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Boundary All Zeros - Select Bus_data");
            Bus_data = 32'h0000_0000;
            Mdata_in = 32'hFFFF_FFFF;
            Mem_read_enable = 1'b0;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Boundary All Ones - Select Mdata_in");
            Bus_data = 32'h0000_0000;
            Mdata_in = 32'hFFFF_FFFF;
            Mem_read_enable = 1'b1;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Alternating Pattern - Select Bus_data");
            Bus_data = 32'h5555_5555;
            Mdata_in = 32'hAAAA_AAAA;
            Mem_read_enable = 1'b0;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Alternating Pattern - Select Mdata_in");
            Bus_data = 32'h5555_5555;
            Mdata_in = 32'hAAAA_AAAA;
            Mem_read_enable = 1'b1;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Random Data Values");
            Bus_data = 32'hDEAD_BEEF;
            Mdata_in = 32'hCAFE_BABE;
            Mem_read_enable = 1'b1;
            #1;

            check_outputs(32'hCAFE_BABE);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Toggle Selector bit with specific values");
            Bus_data = 32'h00FF_00FF;
            Mdata_in = 32'hFF00_FF00;
            Mem_read_enable = 1'b0;
            #1;

            check_outputs(32'h00FF_00FF);
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
        input [31:0] expected_MDMux_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_MDMux_out === (expected_MDMux_out ^ MDMux_out ^ expected_MDMux_out)) begin
                $display("PASS");
                $display("  Outputs: MDMux_out=%h",
                         MDMux_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MDMux_out=%h",
                         expected_MDMux_out);
                $display("  Got:      MDMux_out=%h",
                         MDMux_out);
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
