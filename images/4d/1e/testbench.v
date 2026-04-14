`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] address;
    reg clock;
    reg [7:0] dataIn;
    reg reset;
    reg writeEn;
    wire [7:0] ramOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clock(clock),
        .dataIn(dataIn),
        .reset(reset),
        .writeEn(writeEn),
        .ramOut(ramOut)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 0;
            writeEn = 0;
            address = 0;
            dataIn = 0;
            @(posedge clock);
            #1;
            reset = 1;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write and Read (Addr 0)", test_num);
            reset_dut();


            address = 5'd0;
            dataIn = 8'h55;
            writeEn = 1;
            @(posedge clock);
            #1;


            writeEn = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary Check (Addr 31)", test_num);
            reset_dut();


            address = 5'd31;
            dataIn = 8'hAA;
            writeEn = 1;
            @(posedge clock);
            #1;


            writeEn = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overwrite Check", test_num);
            reset_dut();


            address = 5'd15;
            dataIn = 8'h11;
            writeEn = 1;
            @(posedge clock);
            #1;


            dataIn = 8'h99;
            @(posedge clock);
            #1;


            writeEn = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(8'h99);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data Persistence/Cross-talk check", test_num);
            reset_dut();


            address = 5'd5;
            dataIn = 8'hD1;
            writeEn = 1;
            @(posedge clock);
            #1;


            address = 5'd10;
            dataIn = 8'hD2;
            writeEn = 1;
            @(posedge clock);
            #1;


            address = 5'd5;
            writeEn = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(8'hD1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write Enable verification", test_num);
            reset_dut();


            address = 5'd2;
            dataIn = 8'hEE;
            writeEn = 1;
            @(posedge clock);
            #1;


            address = 5'd2;
            dataIn = 8'hFF;
            writeEn = 0;
            @(posedge clock);
            #1;


            #1;



            check_outputs(8'hEE);
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
        input [7:0] expected_ramOut;
        begin
            if (expected_ramOut === (expected_ramOut ^ ramOut ^ expected_ramOut)) begin
                $display("PASS");
                $display("  Outputs: ramOut=%h",
                         ramOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ramOut=%h",
                         expected_ramOut);
                $display("  Got:      ramOut=%h",
                         ramOut);
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
        $dumpvars(0,address, clock, dataIn, reset, writeEn, ramOut);
    end

endmodule
