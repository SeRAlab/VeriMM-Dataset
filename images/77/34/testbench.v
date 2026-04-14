`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Ack;
    reg Clk;
    reg [7:0] DataIn;
    reg [7:0] key;
    wire [7:0] DataOut;
    wire Ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Ack(Ack),
        .Clk(Clk),
        .DataIn(DataIn),
        .key(key),
        .DataOut(DataOut),
        .Ready(Ready)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Ack = 1'b1;
            DataIn = 8'h00;
            key = 8'h00;
            @(posedge Clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase 001: 0xAA XOR 0x55");
            Ack = 1'b0;
            DataIn = 8'hAA;
            key = 8'h55;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase 002: 0xF0 XOR 0x00");
            Ack = 1'b0;
            DataIn = 8'hF0;
            key = 8'h00;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(8'hF0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase 003: 0x12 XOR 0x12");
            Ack = 1'b0;
            DataIn = 8'h12;
            key = 8'h12;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase 004: 0xFF XOR 0xFF");
            Ack = 1'b0;
            DataIn = 8'hFF;
            key = 8'hFF;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase 005: 0x12 XOR 0x34");
            Ack = 1'b0;
            DataIn = 8'h12;
            key = 8'h34;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(8'h26, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Running Testcase 006: Verify Ack sets Ready LOW");



            #1;




            check_outputs(DataOut, 1'b0);
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
        input [7:0] expected_DataOut;
        input expected_Ready;
        begin
            if (expected_DataOut === (expected_DataOut ^ DataOut ^ expected_DataOut) &&
                expected_Ready === (expected_Ready ^ Ready ^ expected_Ready)) begin
                $display("PASS");
                $display("  Outputs: DataOut=%h, Ready=%b",
                         DataOut, Ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DataOut=%h, Ready=%b",
                         expected_DataOut, expected_Ready);
                $display("  Got:      DataOut=%h, Ready=%b",
                         DataOut, Ready);
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
        $dumpvars(0,Ack, Clk, DataIn, key, DataOut, Ready);
    end

endmodule
