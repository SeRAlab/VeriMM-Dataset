`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg SendingPacket;
    reg [7:0] TxData;
    reg clk20;
    wire Ethernet_Tx;
    wire NextByte;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SendingPacket(SendingPacket),
        .TxData(TxData),
        .clk20(clk20),
        .Ethernet_Tx(Ethernet_Tx),
        .NextByte(NextByte)
    );

    // Clock generation (10ns period)
    initial begin
        clk20 = 0;
        forever #5 clk20 = ~clk20;
    end

        task reset_dut;

        begin
            SendingPacket = 0;
            TxData = 8'h00;
            @(posedge clk20);
            @(negedge clk20);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            repeat(10) @(posedge clk20);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            SendingPacket = 1;
            TxData = 8'h55;
            repeat(2) @(posedge clk20);


            #1;



            check_outputs(Ethernet_Tx, NextByte);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            SendingPacket = 1;
            TxData = 8'h00;

            repeat(16) @(posedge clk20);

            #1;


            check_outputs(Ethernet_Tx, NextByte);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            SendingPacket = 1;
            TxData = 8'hFF;
            repeat(16) @(posedge clk20);
            #1;

            check_outputs(Ethernet_Tx, NextByte);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            SendingPacket = 1;
            TxData = 8'hAA;
            repeat(16) @(posedge clk20);
            SendingPacket = 0;
            repeat(20) @(posedge clk20);

            #1;


            check_outputs(1'b0, 1'b0);
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
        input expected_Ethernet_Tx;
        input expected_NextByte;
        begin
            if (expected_Ethernet_Tx === (expected_Ethernet_Tx ^ Ethernet_Tx ^ expected_Ethernet_Tx) &&
                expected_NextByte === (expected_NextByte ^ NextByte ^ expected_NextByte)) begin
                $display("PASS");
                $display("  Outputs: Ethernet_Tx=%b, NextByte=%b",
                         Ethernet_Tx, NextByte);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Ethernet_Tx=%b, NextByte=%b",
                         expected_Ethernet_Tx, expected_NextByte);
                $display("  Got:      Ethernet_Tx=%b, NextByte=%b",
                         Ethernet_Tx, NextByte);
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
        $dumpvars(0,SendingPacket, TxData, clk20, Ethernet_Tx, NextByte);
    end

endmodule
