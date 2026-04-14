`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] address;
    reg clock;
    reg rom_enable;
    wire [7:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clock(clock),
        .rom_enable(rom_enable),
        .data(data)
    );
    task testcase001;

        begin
            reset_dut();
            rom_enable = 0;
            address = 6'd3;
            @(posedge clock);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            rom_enable = 1;
            address = 6'd0;
            @(posedge clock);
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            rom_enable = 1;
            address = 6'd1;
            @(posedge clock);
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            rom_enable = 1;
            address = 6'd3;
            @(posedge clock);
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            rom_enable = 1;
            address = 6'd5;
            @(posedge clock);
            #1;

            check_outputs(8'h20);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            rom_enable = 1;
            address = 6'd7;
            @(posedge clock);
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase007;

        begin
            reset_dut();

            rom_enable = 1;
            address = 6'd4;
            @(posedge clock);

            rom_enable = 0;
            @(posedge clock);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            rom_enable = 1;
            address = 6'd8;
            @(posedge clock);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            rom_enable = 1;
            address = 6'd15;
            @(posedge clock);
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data === (expected_data ^ data ^ expected_data)) begin
                $display("PASS");
                $display("  Outputs: data=%h",
                         data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h",
                         expected_data);
                $display("  Got:      data=%h",
                         data);
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
