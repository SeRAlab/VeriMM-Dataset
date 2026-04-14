`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [8:0] data;
    reg [4:0] rdaddress;
    reg [4:0] wraddress;
    reg wren;
    wire [8:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data(data),
        .rdaddress(rdaddress),
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
        wren = 0;
        wraddress = 0;
        rdaddress = 0;
        data = 0;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Basic Write/Read Address 5");
        reset_dut();


        wren = 1;
        wraddress = 5'd5;
        data = 9'h1A5;
        @(posedge clock);
        #1;


        wren = 0;
        rdaddress = 5'd5;
        @(posedge clock);
        #1;

        #1;


        check_outputs(9'h1A5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Verify wren=0 prevents writing");
        reset_dut();


        wren = 1;
        wraddress = 5'd10;
        data = 9'h0FF;
        @(posedge clock);
        #1;


        wren = 0;
        wraddress = 5'd10;
        data = 9'h000;
        @(posedge clock);
        #1;


        rdaddress = 5'd10;
        @(posedge clock);
        #1;

        #1;


        check_outputs(9'h0FF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Simultaneous Read (Addr 2) and Write (Addr 15)");
        reset_dut();


        wren = 1;
        wraddress = 5'd2;
        data = 9'h022;
        @(posedge clock);
        #1;


        wren = 1;
        wraddress = 5'd15;
        data = 9'h1BB;
        rdaddress = 5'd2;
        @(posedge clock);
        #1;


        #1;



        check_outputs(9'h022);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Consecutive writes to 0, 1, 2 and read 1");
        reset_dut();


        wren = 1; wraddress = 5'd0; data = 9'h111; @(posedge clock); #1;

        wren = 1; wraddress = 5'd1; data = 9'h122; @(posedge clock); #1;

        wren = 1; wraddress = 5'd2; data = 9'h133; @(posedge clock); #1;


        wren = 0;
        rdaddress = 5'd1;
        @(posedge clock);
        #1;

        #1;


        check_outputs(9'h122);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Boundary address 31 test");
        reset_dut();

        wren = 1;
        wraddress = 5'd31;
        data = 9'h1FF;
        @(posedge clock);
        #1;

        rdaddress = 5'd31;
        @(posedge clock);
        #1;

        #1;


        check_outputs(9'h1FF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Overwriting address 20");
        reset_dut();


        wren = 1; wraddress = 5'd20; data = 9'h0AA; @(posedge clock); #1;

        wren = 1; wraddress = 5'd20; data = 9'h055; @(posedge clock); #1;

        rdaddress = 5'd20;
        @(posedge clock);
        #1;

        #1;


        check_outputs(9'h055);
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
        input [8:0] expected_q;
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
        $dumpvars(0,clock, data, rdaddress, wraddress, wren, q);
    end

endmodule
