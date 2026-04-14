`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [7:0] data;
    reg [10:0] rdaddress;
    reg rden_b;
    reg [11:0] wraddress;
    reg wren;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data(data),
        .rdaddress(rdaddress),
        .rden_b(rden_b),
        .wraddress(wraddress),
        .wren(wren),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            wren = 0;
            rden_b = 1;
            data = 0;
            rdaddress = 0;
            wraddress = 0;
            @(posedge clock);
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Writing 4 bytes to Word 0 and reading back.");

            @(posedge clock);
            wren = 1; wraddress = 12'h000; data = 8'hAA;
            @(posedge clock);
            wren = 1; wraddress = 12'h001; data = 8'hBB;
            @(posedge clock);
            wren = 1; wraddress = 12'h002; data = 8'hCC;
            @(posedge clock);
            wren = 1; wraddress = 12'h003; data = 8'hDD;
            @(posedge clock);
            wren = 0;


            rden_b = 0; rdaddress = 11'h000;
            @(posedge clock);
            #1;
            #1;

            check_outputs(32'hDDCCBBAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Writing to Word 256 (Byte Addresses 1024-1027).");
            @(posedge clock);
            wren = 1; wraddress = 12'd1024; data = 8'h12;
            @(posedge clock);
            wren = 1; wraddress = 12'd1025; data = 8'h34;
            @(posedge clock);
            wren = 1; wraddress = 12'd1026; data = 8'h56;
            @(posedge clock);
            wren = 1; wraddress = 12'd1027; data = 8'h78;
            @(posedge clock);
            wren = 0;


            rden_b = 0; rdaddress = 11'd256;
            @(posedge clock);
            #1;
            #1;

            check_outputs(32'h78563412);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: Verifying that data is NOT written when wren is low.");

            @(posedge clock);
            wren = 1; wraddress = 12'h010; data = 8'hFF;
            @(posedge clock);

            wren = 0; wraddress = 12'h010; data = 8'hEE;
            @(posedge clock);


            rden_b = 0; rdaddress = 11'h004;
            @(posedge clock);
            #1;


            #1;



            check_outputs(32'h000000FF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: Boundary Test - Writing to the last 4 bytes (4092-4095).");
            @(posedge clock);
            wren = 1; wraddress = 12'd4092; data = 8'hDE;
            @(posedge clock);
            wren = 1; wraddress = 12'd4093; data = 8'hAD;
            @(posedge clock);
            wren = 1; wraddress = 12'd4094; data = 8'hBE;
            @(posedge clock);
            wren = 1; wraddress = 12'd4095; data = 8'hEF;
            @(posedge clock);
            wren = 0;


            rden_b = 0; rdaddress = 11'd1023;
            @(posedge clock);
            #1;
            #1;

            check_outputs(32'hEFBEADDE);
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
        input [31:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clock, data, rdaddress, rden_b, wraddress, wren, q);
    end

endmodule
