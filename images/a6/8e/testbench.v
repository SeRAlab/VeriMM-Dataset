`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] address;
    reg [1:0] byteena;
    reg clken;
    reg clock;
    reg [15:0] data;
    reg wren;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .byteena(byteena),
        .clken(clken),
        .clock(clock),
        .data(data),
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
            address = 0;
            byteena = 0;
            clken = 0;
            data = 0;
            wren = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Full Word Write/Read", test_num);
            reset_dut();


            @(posedge clock);
            address = 10'h005;
            data = 16'hABCD;
            byteena = 2'b11;
            clken = 1;
            wren = 1;

            @(posedge clock);

            wren = 0;

            @(posedge clock);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Lower Byte Write Only", test_num);
            reset_dut();


            @(posedge clock);
            address = 10'h00A;
            data = 16'h0000;
            byteena = 2'b11;
            clken = 1;
            wren = 1;


            @(posedge clock);
            data = 16'hBEEF;
            byteena = 2'b01;

            @(posedge clock);

            wren = 0;
            byteena = 2'b11;

            @(posedge clock);
            #1;
            #1;

            check_outputs(16'h00EF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Upper Byte Write Only", test_num);
            reset_dut();


            @(posedge clock);
            address = 10'h00B;
            data = 16'h0000;
            byteena = 2'b11;
            clken = 1;
            wren = 1;


            @(posedge clock);
            data = 16'hBEEF;
            byteena = 2'b10;

            @(posedge clock);

            wren = 0;
            byteena = 2'b11;

            @(posedge clock);
            #1;
            #1;

            check_outputs(16'hBE00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Clock Enable Inhibit Test", test_num);
            reset_dut();


            @(posedge clock);
            address = 10'h010;
            data = 16'h1111;
            byteena = 2'b11;
            clken = 1;
            wren = 1;


            @(posedge clock);
            data = 16'h2222;
            clken = 0;

            @(posedge clock);

            clken = 1;
            wren = 0;

            @(posedge clock);
            #1;
            #1;

            check_outputs(16'h1111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Write Enable Inhibit Test", test_num);
            reset_dut();


            @(posedge clock);
            address = 10'h020;
            data = 16'h3333;
            byteena = 2'b11;
            clken = 1;
            wren = 1;


            @(posedge clock);
            data = 16'h4444;
            wren = 0;

            @(posedge clock);

            address = 10'h020;

            @(posedge clock);
            #1;
            #1;

            check_outputs(16'h3333);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Addressing Logic Test", test_num);
            reset_dut();


            @(posedge clock);
            address = 10'h100;
            data = 16'hAAAA;
            clken = 1;
            wren = 1;
            byteena = 2'b11;


            @(posedge clock);
            address = 10'h200;
            data = 16'hBBBB;

            @(posedge clock);

            wren = 0;
            address = 10'h100;

            @(posedge clock);
            #1;
            #1;

            check_outputs(16'hAAAA);
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
        input [15:0] expected_q;
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
        $dumpvars(0,address, byteena, clken, clock, data, wren, q);
    end

endmodule
