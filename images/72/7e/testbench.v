`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clk;
    reg [15:0] data_write;
    reg lds;
    reg reset_n;
    reg rw;
    reg uds;
    wire ack;
    wire [15:0] data_read;
    wire [7:0] leds;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data_write(data_write),
        .lds(lds),
        .reset_n(reset_n),
        .rw(rw),
        .uds(uds),
        .ack(ack),
        .data_read(data_read),
        .leds(leds)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            addr = 0;
            data_write = 0;
            uds = 0;
            lds = 0;
            rw = 0;
            repeat(2) @(posedge clk);
            #1 reset_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 16'h0000, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            addr = 8'h00;
            data_write = 16'hA500;
            rw = 0;
            uds = 1;
            lds = 0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(0, 16'h0000, 8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            addr = 8'h00;
            data_write = 16'h3C00;
            rw = 0; uds = 1; lds = 0;
            @(posedge clk);
            #1;


            rw = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1, 16'h3C00, 8'h3C);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            addr = 8'hFF;
            data_write = 16'hFF00;
            rw = 0; uds = 1; lds = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(0, 16'h0000, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();




            addr = 8'h00;
            data_write = 16'h5500;
            rw = 0; uds = 0; lds = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(0, 16'h0000, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();


            addr = 8'h00; data_write = 16'hAA00; rw = 0; uds = 1;
            @(posedge clk);
            #1;


            addr = 8'h00; data_write = 16'h5500; rw = 0; uds = 1;
            @(posedge clk);
            #1;


            uds = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(0, 16'h0000, 8'h55);
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
        input expected_ack;
        input [15:0] expected_data_read;
        input [7:0] expected_leds;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_data_read === (expected_data_read ^ data_read ^ expected_data_read) &&
                expected_leds === (expected_leds ^ leds ^ expected_leds)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, data_read=%h, leds=%h",
                         ack, data_read, leds);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, data_read=%h, leds=%h",
                         expected_ack, expected_data_read, expected_leds);
                $display("  Got:      ack=%b, data_read=%h, leds=%h",
                         ack, data_read, leds);
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
        $dumpvars(0,addr, clk, data_write, lds, reset_n, rw, uds, ack, data_read, leds);
    end

endmodule
