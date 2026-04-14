`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg ready;
    reg [2:0] source;
    reg [4:0] volume;
    wire [7:0] command_address;
    wire [15:0] command_data;
    wire command_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .ready(ready),
        .source(source),
        .volume(volume),
        .command_address(command_address),
        .command_data(command_data),
        .command_valid(command_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            ready = 0;
            source = 3'b000;
            volume = 5'b00000;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Check initial Master Volume command (Addr 02h, Vol 0)", test_num);
            reset_dut();

            volume = 5'b00000;
            ready = 1;
            @(posedge clock);
            #2;



            #1;




            check_outputs(8'h02, 16'h1F1F, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Check Aux Volume command (Addr 04h, Vol 5'b01010)", test_num);
            reset_dut();

            volume = 5'b01010;
            ready = 1;
            @(posedge clock);
            #1;
            @(posedge clock);
            #2;


            #1;



            check_outputs(8'h04, 16'h1515, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Check Record Select command (Addr 1Ah, Source 3'b101)", test_num);
            reset_dut();

            source = 3'b101;
            volume = 5'b11111;
            ready = 1;


            for (i = 0; i < 9; i = i + 1) begin
                @(posedge clock);
                #1;
            end

            @(posedge clock);
            #2;


            #1;



            check_outputs(8'h1A, 16'h0005, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify ready-gating logic", test_num);
            reset_dut();

            volume = 5'b00000;
            ready = 1;
            @(posedge clock);
            #1;
            ready = 0;
            @(posedge clock);
            @(posedge clock);
            #2;


            #1;



            check_outputs(8'h04, 16'h1F1F, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify command_valid de-asserts after sequence", test_num);
            reset_dut();

            ready = 1;

            for (i = 0; i < 11; i = i + 1) begin
                @(posedge clock);
                #1;
            end


            #2;
            #1;

            check_outputs(command_address, command_data, 1'b0);
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
        input [7:0] expected_command_address;
        input [15:0] expected_command_data;
        input expected_command_valid;
        begin
            if (expected_command_address === (expected_command_address ^ command_address ^ expected_command_address) &&
                expected_command_data === (expected_command_data ^ command_data ^ expected_command_data) &&
                expected_command_valid === (expected_command_valid ^ command_valid ^ expected_command_valid)) begin
                $display("PASS");
                $display("  Outputs: command_address=%h, command_data=%h, command_valid=%b",
                         command_address, command_data, command_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: command_address=%h, command_data=%h, command_valid=%b",
                         expected_command_address, expected_command_data, expected_command_valid);
                $display("  Got:      command_address=%h, command_data=%h, command_valid=%b",
                         command_address, command_data, command_valid);
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
        $dumpvars(0,clock, ready, source, volume, command_address, command_data, command_valid);
    end

endmodule
