`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] Address_in;
    reg Clock_in;
    reg [7:0] Data_in;
    reg Write_Enable_in;
    wire [7:0] Data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Address_in(Address_in),
        .Clock_in(Clock_in),
        .Data_in(Data_in),
        .Write_Enable_in(Write_Enable_in),
        .Data_out(Data_out)
    );

    // Clock generation (10ns period)
    initial begin
        Clock_in = 0;
        forever #5 Clock_in = ~Clock_in;
    end

        task reset_dut;

        begin
            Address_in = 8'h0;
            Data_in = 8'h0;
            Write_Enable_in = 1'b0;
            @(posedge Clock_in);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Check Initial Zero State");
            reset_dut();
            Address_in = 8'h55;
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Basic Write and Read");
            reset_dut();
            Address_in = 8'h0A;
            Data_in = 8'hA5;
            Write_Enable_in = 1'b1;
            @(posedge Clock_in);
            #1;
            Write_Enable_in = 1'b0;
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Overwriting Memory Location");
            reset_dut();

            Address_in = 8'h20;
            Data_in = 8'h11;
            Write_Enable_in = 1'b1;
            @(posedge Clock_in);
            #1;

            Data_in = 8'h22;
            @(posedge Clock_in);
            #1;
            Write_Enable_in = 1'b0;
            #2;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Write Enable Low Check");
            reset_dut();

            Address_in = 8'h40;
            Data_in = 8'hBC;
            Write_Enable_in = 1'b1;
            @(posedge Clock_in);
            #1;

            Write_Enable_in = 1'b0;
            Data_in = 8'hFF;
            @(posedge Clock_in);
            #1;
            #1;

            check_outputs(8'hBC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Asynchronous Read Address Change");
            reset_dut();

            Address_in = 8'h10;
            Data_in = 8'hDE;
            Write_Enable_in = 1'b1;
            @(posedge Clock_in);
            #1;

            Address_in = 8'h11;
            Data_in = 8'hAD;
            @(posedge Clock_in);
            #1;
            Write_Enable_in = 1'b0;

            Address_in = 8'h10;
            #5;
            #1;

            check_outputs(8'hDE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Boundary Address Testing");
            reset_dut();

            Address_in = 8'hFF;
            Data_in = 8'h66;
            Write_Enable_in = 1'b1;
            @(posedge Clock_in);
            #1;
            Write_Enable_in = 1'b0;
            #2;
            #1;

            check_outputs(8'h66);
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
        input [7:0] expected_Data_out;
        begin
            if (expected_Data_out === (expected_Data_out ^ Data_out ^ expected_Data_out)) begin
                $display("PASS");
                $display("  Outputs: Data_out=%h",
                         Data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Data_out=%h",
                         expected_Data_out);
                $display("  Got:      Data_out=%h",
                         Data_out);
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
        $dumpvars(0,Address_in, Clock_in, Data_in, Write_Enable_in, Data_out);
    end

endmodule
