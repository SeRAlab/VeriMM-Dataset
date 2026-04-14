`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg [7:0] DataIn;
    reg DataInValid;
    reg DataOutReady;
    reg [31:0] ProcessorAddress;
    reg [31:0] ProcessorDataOut;
    reg ProcessorMemRead;
    reg ProcessorMemWrite;
    reg Reset;
    wire DataInReady;
    wire [7:0] DataOut;
    wire DataOutValid;
    wire [31:0] ProcessorDataIn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clock(Clock),
        .DataIn(DataIn),
        .DataInValid(DataInValid),
        .DataOutReady(DataOutReady),
        .ProcessorAddress(ProcessorAddress),
        .ProcessorDataOut(ProcessorDataOut),
        .ProcessorMemRead(ProcessorMemRead),
        .ProcessorMemWrite(ProcessorMemWrite),
        .Reset(Reset),
        .DataInReady(DataInReady),
        .DataOut(DataOut),
        .DataOutValid(DataOutValid),
        .ProcessorDataIn(ProcessorDataIn)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin
            Reset = 1;
            DataIn = 0;
            DataInValid = 0;
            DataOutReady = 0;
            ProcessorAddress = 0;
            ProcessorDataOut = 0;
            ProcessorMemRead = 0;
            ProcessorMemWrite = 0;
            @(posedge Clock);
            #1 Reset = 0;
            @(posedge Clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase001: Reset State Check");
            reset_dut();


            #1;



            check_outputs(1'b1, 8'h00, 1'b0, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase002: UART to Processor Data Transfer");
            reset_dut();


            @(posedge Clock);
            DataIn = 8'hA5;
            DataInValid = 1;


            @(posedge Clock);
            DataInValid = 0;
            ProcessorAddress = 32'h00000000;
            ProcessorMemRead = 1;

            @(posedge Clock);
            #1;
            #1;

            check_outputs(1'b1, 8'h00, 1'b0, 32'h000000A5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase003: Processor to UART Data Transfer");
            reset_dut();


            @(posedge Clock);
            ProcessorAddress = 32'h00000004;
            ProcessorDataOut = 32'h0000005A;
            ProcessorMemWrite = 1;


            @(posedge Clock);
            ProcessorMemWrite = 0;
            DataOutReady = 1;

            @(posedge Clock);
            #1;

            #1;


            check_outputs(1'b1, 8'h5A, 1'b1, 32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase004: Address/Control Signal Sensitivity");
            reset_dut();


            @(posedge Clock);
            DataIn = 8'hFF;
            DataInValid = 1;


            @(posedge Clock);
            DataInValid = 0;
            ProcessorAddress = 32'hFFFFFFFF;
            ProcessorMemRead = 0;

            @(posedge Clock);
            #1;
            #1;

            check_outputs(1'b1, 8'h00, 1'b0, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase005: DataInReady Handshake Check");
            reset_dut();


            DataInValid = 1;
            DataIn = 8'h12;

            repeat(2) @(posedge Clock);


            #1;
            #1;

            check_outputs(1'b1, 8'h00, 1'b0, 32'h00000000);
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
        input expected_DataInReady;
        input [7:0] expected_DataOut;
        input expected_DataOutValid;
        input [31:0] expected_ProcessorDataIn;
        begin
            if (expected_DataInReady === (expected_DataInReady ^ DataInReady ^ expected_DataInReady) &&
                expected_DataOut === (expected_DataOut ^ DataOut ^ expected_DataOut) &&
                expected_DataOutValid === (expected_DataOutValid ^ DataOutValid ^ expected_DataOutValid) &&
                expected_ProcessorDataIn === (expected_ProcessorDataIn ^ ProcessorDataIn ^ expected_ProcessorDataIn)) begin
                $display("PASS");
                $display("  Outputs: DataInReady=%b, DataOut=%h, DataOutValid=%b, ProcessorDataIn=%h",
                         DataInReady, DataOut, DataOutValid, ProcessorDataIn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DataInReady=%b, DataOut=%h, DataOutValid=%b, ProcessorDataIn=%h",
                         expected_DataInReady, expected_DataOut, expected_DataOutValid, expected_ProcessorDataIn);
                $display("  Got:      DataInReady=%b, DataOut=%h, DataOutValid=%b, ProcessorDataIn=%h",
                         DataInReady, DataOut, DataOutValid, ProcessorDataIn);
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
        $dumpvars(0,Clock, DataIn, DataInValid, DataOutReady, ProcessorAddress, ProcessorDataOut, ProcessorMemRead, ProcessorMemWrite, Reset, DataInReady, DataOut, DataOutValid, ProcessorDataIn);
    end

endmodule
