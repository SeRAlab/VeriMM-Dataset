`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] address;
    reg [3:0] byteena;
    reg clock;
    reg [31:0] data;
    reg rden;
    reg wren;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .byteena(byteena),
        .clock(clock),
        .data(data),
        .rden(rden),
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
            data = 0;
            rden = 0;
            wren = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Full Write and Full Read...");
            reset_dut();

            address = 10'h010;
            data = 32'hDEADBEEF;
            byteena = 4'b1111;
            wren = 1; rden = 0;
            @(posedge clock); #1;


            wren = 0; rden = 1;
            @(posedge clock); #1;

            #1;


            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Partial Byte Write...");
            reset_dut();

            address = 10'h020;
            data = 32'hFFFFFFFF;
            byteena = 4'b1111;
            wren = 1; rden = 0;
            @(posedge clock); #1;


            data = 32'h12000034;
            byteena = 4'b0110;
            wren = 1; rden = 0;
            @(posedge clock); #1;


            wren = 0; rden = 1;
            byteena = 4'b1111;
            @(posedge clock); #1;


            #1;



            check_outputs(32'hFF0000FF);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Partial Byte Read Masking...");
            reset_dut();

            address = 10'h030;
            data = 32'h12345678;
            byteena = 4'b1111;
            wren = 1; rden = 0;
            @(posedge clock); #1;


            wren = 0; rden = 1;
            byteena = 4'b1001;
            @(posedge clock); #1;


            #1;



            check_outputs(32'h12000078);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Boundary Address 0...");
            reset_dut();
            address = 10'h000;
            data = 32'hA5A5A5A5;
            byteena = 4'b1111;
            wren = 1; rden = 0;
            @(posedge clock); #1;

            wren = 0; rden = 1;
            @(posedge clock); #1;

            #1;


            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Boundary Address 1023...");
            reset_dut();
            address = 10'h3FF;
            data = 32'h5A5A5A5A;
            byteena = 4'b1111;
            wren = 1; rden = 0;
            @(posedge clock); #1;

            wren = 0; rden = 1;
            @(posedge clock); #1;

            #1;


            check_outputs(32'h5A5A5A5A);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Zero Byte Enable Write/Read...");
            reset_dut();

            address = 10'h040;
            data = 32'hFFFFFFFF;
            byteena = 4'b1111;
            wren = 1; rden = 0;
            @(posedge clock); #1;


            data = 0;
            byteena = 4'b0000;
            wren = 1; rden = 0;
            @(posedge clock); #1;


            wren = 0; rden = 1;
            byteena = 4'b0000;
            @(posedge clock); #1;

            #1;


            check_outputs(32'h00000000);
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
        $dumpvars(0,address, byteena, clock, data, rden, wren, q);
    end

endmodule
