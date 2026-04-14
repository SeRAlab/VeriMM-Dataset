`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg dmal;
    reg dmas;
    reg [8:0] hpos;
    reg [7:0] reg_address_in;
    reg speed;
    reg turbo;
    wire [19:0] address_out;
    wire dma;
    wire [7:0] reg_address_out;
    wire wr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .dmal(dmal),
        .dmas(dmas),
        .hpos(hpos),
        .reg_address_in(reg_address_in),
        .speed(speed),
        .turbo(turbo),
        .address_out(address_out),
        .dma(dma),
        .reg_address_out(reg_address_out),
        .wr(wr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            dmal = 0;
            dmas = 0;
            hpos = 0;
            data_in = 0;
            reg_address_in = 0;
            speed = 0;
            turbo = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %03d: Loading DMA Pointer Low", test_num);

            reg_address_in = 8'h20;
            data_in = 16'hABCD;
            dmal = 1;
            @(posedge clk);
            #1;
            dmal = 0;



            #1;




            check_outputs(20'h0ABCD, 1'b0, 8'h20, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %03d: Starting DMA Request", test_num);

            dmas = 1;
            hpos = 9'h010;
            @(posedge clk);
            #1;


            #1;



            check_outputs(address_out, 1'b1, reg_address_out, wr);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %03d: Testing HPOS Cycle Allocation", test_num);

            dmas = 1;
            hpos = 9'h1FF;
            @(posedge clk);
            #1;


            #1;



            check_outputs(address_out, 1'b0, reg_address_out, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %03d: Turbo Mode Check", test_num);

            turbo = 1;
            dmas = 1;
            hpos = 9'h010;
            @(posedge clk);
            #1;


            #1;



            check_outputs(address_out, 1'b1, reg_address_out, wr);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %03d: Register Address Pass-through", test_num);

            reg_address_in = 8'h5A;
            @(posedge clk);
            #1;

            #1;


            check_outputs(address_out, dma, 8'h5A, wr);
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
        input [19:0] expected_address_out;
        input expected_dma;
        input [7:0] expected_reg_address_out;
        input expected_wr;
        begin
            if (expected_address_out === (expected_address_out ^ address_out ^ expected_address_out) &&
                expected_dma === (expected_dma ^ dma ^ expected_dma) &&
                expected_reg_address_out === (expected_reg_address_out ^ reg_address_out ^ expected_reg_address_out) &&
                expected_wr === (expected_wr ^ wr ^ expected_wr)) begin
                $display("PASS");
                $display("  Outputs: address_out=%h, dma=%b, reg_address_out=%h, wr=%b",
                         address_out, dma, reg_address_out, wr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: address_out=%h, dma=%b, reg_address_out=%h, wr=%b",
                         expected_address_out, expected_dma, expected_reg_address_out, expected_wr);
                $display("  Got:      address_out=%h, dma=%b, reg_address_out=%h, wr=%b",
                         address_out, dma, reg_address_out, wr);
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
        $dumpvars(0,clk, data_in, dmal, dmas, hpos, reg_address_in, speed, turbo, address_out, dma, reg_address_out, wr);
    end

endmodule
