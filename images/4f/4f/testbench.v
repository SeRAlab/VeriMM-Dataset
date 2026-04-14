`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] address;
    reg clock;
    reg reset;
    reg write;
    reg [15:0] writeData;
    wire [15:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clock(clock),
        .reset(reset),
        .write(write),
        .writeData(writeData),
        .data(data)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        @(posedge clock);
        reset = 1;
        write = 0;
        address = 4'h0;
        writeData = 16'h0000;
        @(posedge clock);
        reset = 0;
        @(posedge clock);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Attempt to write 0xABCD to address 0x1", test_num);

        @(negedge clock);
        write = 1;
        address = 4'h1;
        writeData = 16'hABCD;

        @(posedge clock);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Reset signal active with data input", test_num);

        @(negedge clock);
        reset = 1;
        write = 1;
        address = 4'hF;
        writeData = 16'hFFFF;

        @(posedge clock);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Read/Inactive write state", test_num);

        @(negedge clock);
        write = 0;
        address = 4'h5;
        writeData = 16'h5555;

        @(posedge clock);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Rapid input changes", test_num);

        @(negedge clock);
        write = 1;
        address = 4'hA;
        writeData = 16'h1234;
        #2 address = 4'hB;
        #2 writeData = 16'h5678;

        @(posedge clock);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: All inputs high", test_num);

        @(negedge clock);
        write = 1;
        address = 4'hF;
        writeData = 16'hFFFF;
        reset = 1;

        @(posedge clock);
        #1;
        #1;

        check_outputs(16'h0000);
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
        input [15:0] expected_data;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,address, clock, reset, write, writeData, data);
    end

endmodule
