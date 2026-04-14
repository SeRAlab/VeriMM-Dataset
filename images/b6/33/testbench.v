`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [39:0] data;
    reg [4:0] rdaddress;
    reg rdclock;
    reg reset;
    reg [4:0] wraddress;
    reg wrclock;
    reg wren;
    wire [39:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .rdaddress(rdaddress),
        .rdclock(rdclock),
        .reset(reset),
        .wraddress(wraddress),
        .wrclock(wrclock),
        .wren(wren),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        rdclock = 0;
        forever #5 rdclock = ~rdclock;
    end

        task reset_dut;

    begin
        reset = 1;
        data = 0;
        rdaddress = 0;
        wraddress = 0;
        wren = 0;
        @(posedge rdclock);
        #2;
        reset = 0;
        @(posedge rdclock);
        #2;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Write and Read back", test_num);


        @(posedge wrclock);
        wraddress = 5'd15;
        data = 40'hFEDCBA9876543210;
        wren = 1;
        @(posedge wrclock);
        wren = 0;


        @(posedge rdclock);
        rdaddress = 5'd15;
        @(posedge rdclock);

        #1;
        #1;

        check_outputs(40'hFEDCBA9876543210);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Reset behavior on Output Register", test_num);


        @(posedge wrclock);
        wraddress = 5'd5;
        data = 40'hAAAAAAAAAA;
        wren = 1;
        @(posedge wrclock);
        wren = 0;


        @(posedge rdclock);
        rdaddress = 5'd5;
        @(posedge rdclock);


        @(posedge rdclock);
        reset = 1;
        @(posedge rdclock);
        #1;
        #1;

        check_outputs(40'h0);
        reset = 0;
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Write Enable (wren) logic", test_num);


        @(posedge wrclock);
        wraddress = 5'd20;
        data = 40'h5555555555;
        wren = 0;
        @(posedge wrclock);


        @(posedge rdclock);
        rdaddress = 5'd20;
        @(posedge rdclock);
        #1;
        #1;

        check_outputs(40'h0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Address (31)", test_num);

        @(posedge wrclock);
        wraddress = 5'd31;
        data = 40'hFFFFFFFFFFFFFFFF;
        wren = 1;
        @(posedge wrclock);
        wren = 0;

        @(posedge rdclock);
        rdaddress = 5'd31;
        @(posedge rdclock);
        #1;
        #1;

        check_outputs(40'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Simultaneous Access to Different Addresses", test_num);


        @(posedge wrclock);
        wraddress = 5'd2;
        data = 40'h1111111111;
        wren = 1;
        @(posedge wrclock);
        wren = 0;


        fork
            begin
                @(posedge wrclock);
                wraddress = 5'd3;
                data = 40'h3333333333;
                wren = 1;
                @(posedge wrclock);
                wren = 0;
            end
            begin
                @(posedge rdclock);
                rdaddress = 5'd2;
                @(posedge rdclock);
            end
        join

        #1;
        #1;

        check_outputs(40'h1111111111);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Overwriting memory location", test_num);


        @(posedge wrclock);
        wraddress = 5'd7;
        data = 40'h1234567890;
        wren = 1;
        @(posedge wrclock);


        data = 40'h0987654321;
        @(posedge wrclock);
        wren = 0;


        @(posedge rdclock);
        rdaddress = 5'd7;
        @(posedge rdclock);
        #1;
        #1;

        check_outputs(40'h0987654321);
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
        input [39:0] expected_q;
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
        $dumpvars(0,data, rdaddress, rdclock, reset, wraddress, wrclock, wren, q);
    end

endmodule
