`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] address;
    reg aen;
    reg clk;
    reg [15:0] data_in;
    reg [8:0] hpos;
    reg reset;
    wire attach;
    wire [1:0] sprdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .aen(aen),
        .clk(clk),
        .data_in(data_in),
        .hpos(hpos),
        .reset(reset),
        .attach(attach),
        .sprdata(sprdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            aen = 0;
            address = 0;
            data_in = 0;
            hpos = 0;
            repeat(2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Checking attach bit write...");
            reset_dut();


            @(posedge clk);
            aen = 1;
            address = 2'b01;
            data_in = 16'h0080;
            @(posedge clk);
            aen = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Loading Sprite Data Plane 0 (MSB set)...");
            reset_dut();


            aen = 1; address = 2'b00; data_in = 16'd20; @(posedge clk);

            aen = 1; address = 2'b10; data_in = 16'h8000; @(posedge clk);

            aen = 1; address = 2'b11; data_in = 16'h0000; @(posedge clk);
            aen = 0;


            hpos = 9'd20;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Loading Sprite Data Plane 1 (MSB set)...");
            reset_dut();


            aen = 1; address = 2'b00; data_in = 16'd5; @(posedge clk);
            aen = 1; address = 2'b10; data_in = 16'h0000; @(posedge clk);
            aen = 1; address = 2'b11; data_in = 16'h8000; @(posedge clk);
            aen = 0;

            hpos = 9'd5;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 2'b10);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Checking bit shifting (Bit 14)...");
            reset_dut();


            aen = 1; address = 2'b00; data_in = 16'd100; @(posedge clk);

            aen = 1; address = 2'b10; data_in = 16'h4000; @(posedge clk);
            aen = 1; address = 2'b11; data_in = 16'h4000; @(posedge clk);
            aen = 0;

            hpos = 9'd100;
            @(posedge clk);
            hpos = 9'd101;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 2'b11);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Verifying aen gating (no write when aen=0)...");
            reset_dut();


            aen = 0;
            address = 2'b01;
            data_in = 16'h0080;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 2'b00);
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
        input expected_attach;
        input [1:0] expected_sprdata;
        begin
            if (expected_attach === (expected_attach ^ attach ^ expected_attach) &&
                expected_sprdata === (expected_sprdata ^ sprdata ^ expected_sprdata)) begin
                $display("PASS");
                $display("  Outputs: attach=%b, sprdata=%h",
                         attach, sprdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: attach=%b, sprdata=%h",
                         expected_attach, expected_sprdata);
                $display("  Got:      attach=%b, sprdata=%h",
                         attach, sprdata);
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
        $dumpvars(0,address, aen, clk, data_in, hpos, reset, attach, sprdata);
    end

endmodule
