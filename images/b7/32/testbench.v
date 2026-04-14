`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg clk;
    reg cpu_read;
    reg [7:0] data_from_cpu;
    reg [7:0] data_from_ram;
    reg [15:0] dmc_dma_addr;
    reg dmc_trigger;
    reg odd_cycle;
    reg reset;
    reg sprite_trigger;
    wire [15:0] aout;
    wire aout_enable;
    wire [7:0] data_to_ram;
    wire dmc_ack;
    wire pause_cpu;
    wire read;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .cpu_read(cpu_read),
        .data_from_cpu(data_from_cpu),
        .data_from_ram(data_from_ram),
        .dmc_dma_addr(dmc_dma_addr),
        .dmc_trigger(dmc_trigger),
        .odd_cycle(odd_cycle),
        .reset(reset),
        .sprite_trigger(sprite_trigger),
        .aout(aout),
        .aout_enable(aout_enable),
        .data_to_ram(data_to_ram),
        .dmc_ack(dmc_ack),
        .pause_cpu(pause_cpu),
        .read(read)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ce = 0;
            reset = 1;
            sprite_trigger = 0;
            dmc_trigger = 0;
            cpu_read = 1;
            data_from_cpu = 8'h00;
            data_from_ram = 8'h00;
            dmc_dma_addr = 16'h0000;
            odd_cycle = 0;
            @(posedge clk);
            #1 reset = 0;
            ce = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Idle State Check");
            reset_dut();

            #1;


            check_outputs(16'h0000, 1'b0, 8'h00, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Sprite DMA Initiation");
            reset_dut();


            data_from_cpu = 8'h02;
            sprite_trigger = 1;
            @(posedge clk);
            #1 sprite_trigger = 0;



            repeat(4) @(posedge clk);




            if (pause_cpu === 1'b1 && aout_enable === 1'b1)
                pass_count = pass_count + 1;
            else begin
                $display("FAIL: Sprite DMA did not pause CPU or enable address output");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: DMC DMA Initiation");
            reset_dut();


            dmc_dma_addr = 16'hC000;
            dmc_trigger = 1;
            @(posedge clk);
            #1 dmc_trigger = 0;


            repeat(2) @(posedge clk);



            #1;




            check_outputs(16'hC000, 1'b1, 8'h00, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: DMC interrupting Sprite DMA");
            reset_dut();


            data_from_cpu = 8'h05;
            sprite_trigger = 1;
            @(posedge clk);
            #1 sprite_trigger = 0;
            repeat(5) @(posedge clk);


            dmc_dma_addr = 16'hFFFA;
            dmc_trigger = 1;
            @(posedge clk);
            #1 dmc_trigger = 0;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(16'hFFFA, 1'b1, 8'h00, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Clock Enable (ce) Check");
            reset_dut();


            dmc_dma_addr = 16'h1234;
            dmc_trigger = 1;
            ce = 0;
            repeat(5) @(posedge clk);


            if (aout_enable === 1'b0 && dmc_ack === 1'b0)
                pass_count = pass_count + 1;
            else begin
                $display("FAIL: DMA logic advanced despite ce=0");
                fail_count = fail_count + 1;
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
        input [15:0] expected_aout;
        input expected_aout_enable;
        input [7:0] expected_data_to_ram;
        input expected_dmc_ack;
        input expected_pause_cpu;
        input expected_read;
        begin
            if (expected_aout === (expected_aout ^ aout ^ expected_aout) &&
                expected_aout_enable === (expected_aout_enable ^ aout_enable ^ expected_aout_enable) &&
                expected_data_to_ram === (expected_data_to_ram ^ data_to_ram ^ expected_data_to_ram) &&
                expected_dmc_ack === (expected_dmc_ack ^ dmc_ack ^ expected_dmc_ack) &&
                expected_pause_cpu === (expected_pause_cpu ^ pause_cpu ^ expected_pause_cpu) &&
                expected_read === (expected_read ^ read ^ expected_read)) begin
                $display("PASS");
                $display("  Outputs: aout=%h, aout_enable=%b, data_to_ram=%h, dmc_ack=%b, pause_cpu=%b, read=%b",
                         aout, aout_enable, data_to_ram, dmc_ack, pause_cpu, read);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aout=%h, aout_enable=%b, data_to_ram=%h, dmc_ack=%b, pause_cpu=%b, read=%b",
                         expected_aout, expected_aout_enable, expected_data_to_ram, expected_dmc_ack, expected_pause_cpu, expected_read);
                $display("  Got:      aout=%h, aout_enable=%b, data_to_ram=%h, dmc_ack=%b, pause_cpu=%b, read=%b",
                         aout, aout_enable, data_to_ram, dmc_ack, pause_cpu, read);
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
        $dumpvars(0,ce, clk, cpu_read, data_from_cpu, data_from_ram, dmc_dma_addr, dmc_trigger, odd_cycle, reset, sprite_trigger, aout, aout_enable, data_to_ram, dmc_ack, pause_cpu, read);
    end

endmodule
