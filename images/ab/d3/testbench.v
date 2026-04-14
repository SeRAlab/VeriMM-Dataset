`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] addra;
    reg [1:0] addrb;
    reg clk;
    reg [1:0] dia;
    reg [1:0] dib;
    reg wea;
    reg web;
    wire [1:0] doa;
    wire [1:0] dob;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addra(addra),
        .addrb(addrb),
        .clk(clk),
        .dia(dia),
        .dib(dib),
        .wea(wea),
        .web(web),
        .doa(doa),
        .dob(dob)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        wea = 0;
        web = 0;
        addra = 0;
        addrb = 0;
        dia = 0;
        dib = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: Write 2'b10 to Addr 1 via Port A");
        reset_dut();


        addra = 2'b01;
        dia = 2'b10;
        wea = 1;


        @(negedge clk);
        #2;
        wea = 0;


        #1;



        check_outputs(2'b10, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Write 2'b11 to Addr 3 via Port B");
        reset_dut();


        addrb = 2'b11;
        dib = 2'b11;
        web = 1;

        @(negedge clk);
        #2;
        web = 0;


        #1;



        check_outputs(2'b00, 2'b11);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Simultaneous Writes (Port A: Addr 0, Port B: Addr 2)");
        reset_dut();

        addra = 2'b00; dia = 2'b01; wea = 1;
        addrb = 2'b10; dib = 2'b11; web = 1;

        @(negedge clk);
        #2;
        wea = 0; web = 0;

        #1;


        check_outputs(2'b01, 2'b11);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Data persistence and Write Disable");
        reset_dut();


        addra = 2'b01; dia = 2'b11; wea = 1;
        @(negedge clk);
        #2;


        dia = 2'b00; wea = 0;
        @(negedge clk);
        #2;


        #1;



        check_outputs(2'b11, 2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Overwrite Address 2 via Port A");
        reset_dut();


        addra = 2'b10; dia = 2'b01; wea = 1;
        @(negedge clk);
        #2;


        dia = 2'b10;
        @(negedge clk);
        #2;
        wea = 0;

        #1;


        check_outputs(2'b10, 2'b00);
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
        input [1:0] expected_doa;
        input [1:0] expected_dob;
        begin
            if (expected_doa === (expected_doa ^ doa ^ expected_doa) &&
                expected_dob === (expected_dob ^ dob ^ expected_dob)) begin
                $display("PASS");
                $display("  Outputs: doa=%h, dob=%h",
                         doa, dob);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: doa=%h, dob=%h",
                         expected_doa, expected_dob);
                $display("  Got:      doa=%h, dob=%h",
                         doa, dob);
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
        $dumpvars(0,addra, addrb, clk, dia, dib, wea, web, doa, dob);
    end

endmodule
