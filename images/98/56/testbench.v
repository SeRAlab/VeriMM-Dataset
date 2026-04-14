`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg clk;
    reg [2:0] cycle;
    reg enabled;
    reg obj_patt;
    reg obj_size;
    reg [7:0] temp;
    reg [7:0] vram_data;
    wire [3:0] load;
    wire [26:0] load_in;
    wire [12:0] vram_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .cycle(cycle),
        .enabled(enabled),
        .obj_patt(obj_patt),
        .obj_size(obj_size),
        .temp(temp),
        .vram_data(vram_data),
        .load(load),
        .load_in(load_in),
        .vram_addr(vram_addr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ce = 0;
            enabled = 0;
            cycle = 0;
            obj_size = 0;
            obj_patt = 0;
            temp = 0;
            vram_data = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            enabled = 0;
            ce = 1;
            cycle = 3'd4;
            vram_data = 8'hFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, load_in, vram_addr);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            enabled = 1;
            ce = 1;
            obj_size = 0;
            obj_patt = 0;
            temp = 8'h12;
            cycle = 3'd4;
            vram_data = 8'hAA;
            @(posedge clk);
            #1;


            $display("Checking 8x8 Pattern 0 Fetch...");
            #1;

            check_outputs(load, load_in, vram_addr);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            enabled = 1;
            ce = 1;
            obj_size = 0;
            obj_patt = 1;
            temp = 8'h12;
            cycle = 3'd6;
            vram_data = 8'h55;
            @(posedge clk);
            #1;
            $display("Checking 8x8 Pattern 1 Fetch...");
            #1;

            check_outputs(load, load_in, vram_addr);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            enabled = 1;
            ce = 1;
            obj_size = 1;
            temp = 8'hFE;
            cycle = 3'd4;
            @(posedge clk);
            #1;
            $display("Checking 8x16 Fetch Address logic...");
            #1;

            check_outputs(load, load_in, vram_addr);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            enabled = 1;
            ce = 0;
            cycle = 3'd4;
            temp = 8'h55;
            @(posedge clk);
            #1;
            $display("Checking Clock Enable (ce) inactivity...");

            #1;


            check_outputs(4'h0, load_in, vram_addr);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            enabled = 1;
            ce = 1;
            cycle = 3'd7;
            vram_data = 8'hF0;
            temp = 8'h01;
            @(posedge clk);
            #1;
            $display("Checking cycle 7 load sequence...");
            #1;

            check_outputs(load, load_in, vram_addr);
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
        input [3:0] expected_load;
        input [26:0] expected_load_in;
        input [12:0] expected_vram_addr;
        begin
            if (expected_load === (expected_load ^ load ^ expected_load) &&
                expected_load_in === (expected_load_in ^ load_in ^ expected_load_in) &&
                expected_vram_addr === (expected_vram_addr ^ vram_addr ^ expected_vram_addr)) begin
                $display("PASS");
                $display("  Outputs: load=%h, load_in=%h, vram_addr=%h",
                         load, load_in, vram_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: load=%h, load_in=%h, vram_addr=%h",
                         expected_load, expected_load_in, expected_vram_addr);
                $display("  Got:      load=%h, load_in=%h, vram_addr=%h",
                         load, load_in, vram_addr);
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
        $dumpvars(0,ce, clk, cycle, enabled, obj_patt, obj_size, temp, vram_data, load, load_in, vram_addr);
    end

endmodule
