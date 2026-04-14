`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin


            #2;
        end
        endtask
    task testcase001;

        reg [7:0] val;
        reg [7:0] captured;
        integer i;
        begin
            $display("Testcase 001: Data 8'hAA (10101010)");
            reset_dut();
            test_num = test_num + 1;
            val = 8'hAA;
            data_in = val;
            @(posedge clk); #1;
            for (i = 7; i >= 0; i = i - 1) begin
                captured[i] = serial_out;
                if (i > 0) begin @(posedge clk); #1; end
            end
            if (captured === val) #1;
 check_outputs(serial_out);
            else begin
                $display("FAIL: Data Mismatch! Expected %b, Got %b", val, captured);
                #1;

                check_outputs(~serial_out);
            end
        end
        endtask

    task testcase002;

        reg [7:0] val;
        reg [7:0] captured;
        integer i;
        begin
            $display("Testcase 002: Data 8'h55 (01010101)");
            reset_dut();
            test_num = test_num + 1;
            val = 8'h55;
            data_in = val;
            @(posedge clk); #1;
            for (i = 7; i >= 0; i = i - 1) begin
                captured[i] = serial_out;
                if (i > 0) begin @(posedge clk); #1; end
            end
            if (captured === val) #1;
 check_outputs(serial_out);
            else begin
                $display("FAIL: Data Mismatch! Expected %b, Got %b", val, captured);
                #1;

                check_outputs(~serial_out);
            end
        end
        endtask

    task testcase003;

        reg [7:0] val;
        reg [7:0] captured;
        integer i;
        begin
            $display("Testcase 003: Data 8'hFF (11111111)");
            reset_dut();
            test_num = test_num + 1;
            val = 8'hFF;
            data_in = val;
            @(posedge clk); #1;
            for (i = 7; i >= 0; i = i - 1) begin
                captured[i] = serial_out;
                if (i > 0) begin @(posedge clk); #1; end
            end
            if (captured === val) #1;
 check_outputs(serial_out);
            else begin
                $display("FAIL: Data Mismatch! Expected %b, Got %b", val, captured);
                #1;

                check_outputs(~serial_out);
            end
        end
        endtask

    task testcase004;

        reg [7:0] val;
        reg [7:0] captured;
        integer i;
        begin
            $display("Testcase 004: Data 8'h00 (00000000)");
            reset_dut();
            test_num = test_num + 1;
            val = 8'h00;
            data_in = val;
            @(posedge clk); #1;
            for (i = 7; i >= 0; i = i - 1) begin
                captured[i] = serial_out;
                if (i > 0) begin @(posedge clk); #1; end
            end
            if (captured === val) #1;
 check_outputs(serial_out);
            else begin
                $display("FAIL: Data Mismatch! Expected %b, Got %b", val, captured);
                #1;

                check_outputs(~serial_out);
            end
        end
        endtask

    task testcase005;

        reg [7:0] val;
        reg [7:0] captured;
        integer i;
        begin
            $display("Testcase 005: Data 8'h81 (10000001)");
            reset_dut();
            test_num = test_num + 1;
            val = 8'h81;
            data_in = val;
            @(posedge clk); #1;
            for (i = 7; i >= 0; i = i - 1) begin
                captured[i] = serial_out;
                if (i > 0) begin @(posedge clk); #1; end
            end
            if (captured === val) #1;
 check_outputs(serial_out);
            else begin
                $display("FAIL: Data Mismatch! Expected %b, Got %b", val, captured);
                #1;

                check_outputs(~serial_out);
            end
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
        input expected_serial_out;
        begin
            if (expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: serial_out=%b",
                         serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_out=%b",
                         expected_serial_out);
                $display("  Got:      serial_out=%b",
                         serial_out);
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
        $dumpvars(0,clk, data_in, serial_out);
    end

endmodule
