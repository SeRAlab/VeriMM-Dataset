`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] address;
    reg clock;
    reg [15:0] data_input;
    reg ram_enable;
    reg write_enable;
    wire [15:0] data_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clock(clock),
        .data_input(data_input),
        .ram_enable(ram_enable),
        .write_enable(write_enable),
        .data_output(data_output)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            ram_enable = 0;
            write_enable = 0;
            address = 0;
            data_input = 0;
            @(negedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            @(negedge clock);
            ram_enable = 1;
            write_enable = 1;
            address = 12'h001;
            data_input = 16'hABCD;


            @(negedge clock);
            write_enable = 0;


            @(posedge clock);
            #1;

            $display("Testcase %0d: Basic Write/Read", test_num);
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            @(negedge clock);
            ram_enable = 1;
            write_enable = 1;
            address = 12'h005;
            data_input = 16'h1111;


            @(negedge clock);
            data_input = 16'h2222;


            @(negedge clock);
            write_enable = 0;

            @(posedge clock);
            #1;

            $display("Testcase %0d: Overwrite check", test_num);
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            @(negedge clock);
            ram_enable = 1;
            write_enable = 1;
            address = 12'h00A;
            data_input = 16'hCAFE;


            @(negedge clock);
            ram_enable = 0;
            write_enable = 1;
            data_input = 16'hDEAD;


            @(negedge clock);
            ram_enable = 1;
            write_enable = 0;

            @(posedge clock);
            #1;

            $display("Testcase %0d: Ram Enable Inhibition check", test_num);
            #1;

            check_outputs(16'hCAFE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            @(negedge clock);
            ram_enable = 1;
            write_enable = 1;
            address = 12'hFFF;
            data_input = 16'h55AA;


            @(negedge clock);
            write_enable = 0;

            @(posedge clock);
            #1;

            $display("Testcase %0d: Max Address check", test_num);
            #1;

            check_outputs(16'h55AA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            @(negedge clock);
            ram_enable = 1;
            write_enable = 1;
            address = 12'h100;
            data_input = 16'hAAAA;


            @(negedge clock);
            address = 12'h200;
            data_input = 16'hBBBB;


            @(negedge clock);
            write_enable = 0;
            address = 12'h100;

            @(posedge clock);
            #1;

            $display("Testcase %0d: Multi-address persistence", test_num);
            #1;

            check_outputs(16'hAAAA);
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
        input [15:0] expected_data_output;
        begin
            if (expected_data_output === (expected_data_output ^ data_output ^ expected_data_output)) begin
                $display("PASS");
                $display("  Outputs: data_output=%h",
                         data_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_output=%h",
                         expected_data_output);
                $display("  Got:      data_output=%h",
                         data_output);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,address, clock, data_input, ram_enable, write_enable, data_output);
    end

endmodule
