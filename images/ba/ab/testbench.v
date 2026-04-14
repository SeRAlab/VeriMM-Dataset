`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] address;
    reg clock;
    reg read;
    reg reset;
    reg write;
    reg [31:0] writedata;
    wire busywait;
    wire [31:0] readdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clock(clock),
        .read(read),
        .reset(reset),
        .write(write),
        .writedata(writedata),
        .busywait(busywait),
        .readdata(readdata)
    );
    task wait_busy;

    begin
        @(posedge clock);
        while (busywait === 1'b1) @(posedge clock);
        #1;
    end
        endtask

    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Reset and Initial State");
        reset = 1;
        read = 0;
        write = 0;
        address = 8'h00;
        writedata = 32'h0;
        repeat(2) @(posedge clock);
        reset = 0;
        repeat(2) @(posedge clock);
        #1;

        check_outputs(1'b0, readdata);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Single Write then Read");
        reset = 1;
        #10;
        reset = 0;
        @(posedge clock);


        address = 8'h10;
        writedata = 32'hABCDEFF0;
        write = 1;
        wait_busy();
        write = 0;


        read = 1;
        wait_busy();
        read = 0;

        #1;


        check_outputs(1'b0, 32'hABCDEFF0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Write to Address A, then B, Read A");
        reset = 1;
        #10;
        reset = 0;


        address = 8'h20;
        writedata = 32'h11112222;
        write = 1;
        wait_busy();
        write = 0;


        address = 8'h40;
        writedata = 32'h33334444;
        write = 1;
        wait_busy();
        write = 0;


        address = 8'h20;
        read = 1;
        wait_busy();
        read = 0;

        #1;


        check_outputs(1'b0, 32'h11112222);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Overwrite Address");
        reset = 1;
        #10;
        reset = 0;


        address = 8'hF0;
        writedata = 32'hAAAAAAAA;
        write = 1;
        wait_busy();
        write = 0;


        writedata = 32'h55555555;
        write = 1;
        wait_busy();
        write = 0;


        read = 1;
        wait_busy();
        read = 0;

        #1;


        check_outputs(1'b0, 32'h55555555);
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
        input expected_busywait;
        input [31:0] expected_readdata;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_busywait === (expected_busywait ^ busywait ^ expected_busywait) &&
                expected_readdata === (expected_readdata ^ readdata ^ expected_readdata)) begin
                $display("PASS");
                $display("  Outputs: busywait=%b, readdata=%h",
                         busywait, readdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busywait=%b, readdata=%h",
                         expected_busywait, expected_readdata);
                $display("  Got:      busywait=%b, readdata=%h",
                         busywait, readdata);
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
