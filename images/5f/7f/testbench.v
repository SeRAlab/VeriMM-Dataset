`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg grant;
    reg reset;
    reg [15:0] sram_tcm_data_in;
    reg tcs0_request;
    reg [18:0] tcs0_tcm_address_out;
    reg [1:0] tcs0_tcm_byteenable_n_out;
    reg tcs0_tcm_chipselect_n_out;
    reg [15:0] tcs0_tcm_data_out;
    reg tcs0_tcm_data_outen;
    reg tcs0_tcm_outputenable_n_out;
    reg tcs0_tcm_write_n_out;
    wire request;
    wire [18:0] sram_tcm_address_out;
    wire [1:0] sram_tcm_byteenable_n_out;
    wire sram_tcm_chipselect_n_out;
    wire [15:0] sram_tcm_data_out;
    wire sram_tcm_data_outen;
    wire sram_tcm_outputenable_n_out;
    wire sram_tcm_write_n_out;
    wire tcs0_grant;
    wire [15:0] tcs0_tcm_data_in;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .grant(grant),
        .reset(reset),
        .sram_tcm_data_in(sram_tcm_data_in),
        .tcs0_request(tcs0_request),
        .tcs0_tcm_address_out(tcs0_tcm_address_out),
        .tcs0_tcm_byteenable_n_out(tcs0_tcm_byteenable_n_out),
        .tcs0_tcm_chipselect_n_out(tcs0_tcm_chipselect_n_out),
        .tcs0_tcm_data_out(tcs0_tcm_data_out),
        .tcs0_tcm_data_outen(tcs0_tcm_data_outen),
        .tcs0_tcm_outputenable_n_out(tcs0_tcm_outputenable_n_out),
        .tcs0_tcm_write_n_out(tcs0_tcm_write_n_out),
        .request(request),
        .sram_tcm_address_out(sram_tcm_address_out),
        .sram_tcm_byteenable_n_out(sram_tcm_byteenable_n_out),
        .sram_tcm_chipselect_n_out(sram_tcm_chipselect_n_out),
        .sram_tcm_data_out(sram_tcm_data_out),
        .sram_tcm_data_outen(sram_tcm_data_outen),
        .sram_tcm_outputenable_n_out(sram_tcm_outputenable_n_out),
        .sram_tcm_write_n_out(sram_tcm_write_n_out),
        .tcs0_grant(tcs0_grant),
        .tcs0_tcm_data_in(tcs0_tcm_data_in)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            grant = 0;
            sram_tcm_data_in = 0;
            tcs0_request = 0;
            tcs0_tcm_address_out = 0;
            tcs0_tcm_byteenable_n_out = 2'b11;
            tcs0_tcm_chipselect_n_out = 1'b1;
            tcs0_tcm_data_out = 0;
            tcs0_tcm_data_outen = 0;
            tcs0_tcm_outputenable_n_out = 1'b1;
            tcs0_tcm_write_n_out = 1'b1;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State - High Impedance Check", test_num);
            reset_dut();


            #1;



            check_outputs(
                1'b0,
                19'bz,
                2'bz,
                1'bz,
                16'bz,
                1'bz,
                1'bz,
                1'bz,
                1'b0,
                16'h0
            );
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Request without Grant", test_num);
            reset_dut();
            tcs0_request = 1;
            grant = 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(
                1'b1, 19'bz, 2'bz, 1'bz, 16'bz, 1'bz, 1'bz, 1'bz, 1'b0, 16'h0
            );
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Request with Grant (Active Access)", test_num);
            reset_dut();
            tcs0_request = 1;
            grant = 1;
            tcs0_tcm_address_out = 19'h12345;
            tcs0_tcm_byteenable_n_out = 2'b01;
            tcs0_tcm_chipselect_n_out = 1'b0;
            tcs0_tcm_data_out = 16'hAAAA;
            tcs0_tcm_data_outen = 1'b1;
            tcs0_tcm_outputenable_n_out = 1'b1;
            tcs0_tcm_write_n_out = 1'b0;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(
                1'b1, 19'h12345, 2'b01, 1'b0, 16'hAAAA, 1'b1, 1'b1, 1'b0, 1'b1, 16'h0
            );
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Data Input Path (Read)", test_num);
            reset_dut();
            tcs0_request = 1;
            grant = 1;
            sram_tcm_data_in = 16'hBEEF;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(
                1'b1, 19'h0, 2'b11, 1'b1, 16'h0, 1'b0, 1'b1, 1'b1, 1'b1, 16'hBEEF
            );
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Grant Deassertion mid-access", test_num);
            reset_dut();
            tcs0_request = 1;
            grant = 1;
            tcs0_tcm_address_out = 19'h7FFFF;
            @(posedge clk);
            #1 grant = 0;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(
                1'b1, 19'bz, 2'bz, 1'bz, 16'bz, 1'bz, 1'bz, 1'bz, 1'b0, 16'h0
            );
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
        input expected_request;
        input [18:0] expected_sram_tcm_address_out;
        input [1:0] expected_sram_tcm_byteenable_n_out;
        input expected_sram_tcm_chipselect_n_out;
        input [15:0] expected_sram_tcm_data_out;
        input expected_sram_tcm_data_outen;
        input expected_sram_tcm_outputenable_n_out;
        input expected_sram_tcm_write_n_out;
        input expected_tcs0_grant;
        input [15:0] expected_tcs0_tcm_data_in;
        begin
            if (expected_request === (expected_request ^ request ^ expected_request) &&
                expected_sram_tcm_address_out === (expected_sram_tcm_address_out ^ sram_tcm_address_out ^ expected_sram_tcm_address_out) &&
                expected_sram_tcm_byteenable_n_out === (expected_sram_tcm_byteenable_n_out ^ sram_tcm_byteenable_n_out ^ expected_sram_tcm_byteenable_n_out) &&
                expected_sram_tcm_chipselect_n_out === (expected_sram_tcm_chipselect_n_out ^ sram_tcm_chipselect_n_out ^ expected_sram_tcm_chipselect_n_out) &&
                expected_sram_tcm_data_out === (expected_sram_tcm_data_out ^ sram_tcm_data_out ^ expected_sram_tcm_data_out) &&
                expected_sram_tcm_data_outen === (expected_sram_tcm_data_outen ^ sram_tcm_data_outen ^ expected_sram_tcm_data_outen) &&
                expected_sram_tcm_outputenable_n_out === (expected_sram_tcm_outputenable_n_out ^ sram_tcm_outputenable_n_out ^ expected_sram_tcm_outputenable_n_out) &&
                expected_sram_tcm_write_n_out === (expected_sram_tcm_write_n_out ^ sram_tcm_write_n_out ^ expected_sram_tcm_write_n_out) &&
                expected_tcs0_grant === (expected_tcs0_grant ^ tcs0_grant ^ expected_tcs0_grant) &&
                expected_tcs0_tcm_data_in === (expected_tcs0_tcm_data_in ^ tcs0_tcm_data_in ^ expected_tcs0_tcm_data_in)) begin
                $display("PASS");
                $display("  Outputs: request=%b, sram_tcm_address_out=%h, sram_tcm_byteenable_n_out=%h, sram_tcm_chipselect_n_out=%b, sram_tcm_data_out=%h, sram_tcm_data_outen=%b, sram_tcm_outputenable_n_out=%b, sram_tcm_write_n_out=%b, tcs0_grant=%b, tcs0_tcm_data_in=%h",
                         request, sram_tcm_address_out, sram_tcm_byteenable_n_out, sram_tcm_chipselect_n_out, sram_tcm_data_out, sram_tcm_data_outen, sram_tcm_outputenable_n_out, sram_tcm_write_n_out, tcs0_grant, tcs0_tcm_data_in);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: request=%b, sram_tcm_address_out=%h, sram_tcm_byteenable_n_out=%h, sram_tcm_chipselect_n_out=%b, sram_tcm_data_out=%h, sram_tcm_data_outen=%b, sram_tcm_outputenable_n_out=%b, sram_tcm_write_n_out=%b, tcs0_grant=%b, tcs0_tcm_data_in=%h",
                         expected_request, expected_sram_tcm_address_out, expected_sram_tcm_byteenable_n_out, expected_sram_tcm_chipselect_n_out, expected_sram_tcm_data_out, expected_sram_tcm_data_outen, expected_sram_tcm_outputenable_n_out, expected_sram_tcm_write_n_out, expected_tcs0_grant, expected_tcs0_tcm_data_in);
                $display("  Got:      request=%b, sram_tcm_address_out=%h, sram_tcm_byteenable_n_out=%h, sram_tcm_chipselect_n_out=%b, sram_tcm_data_out=%h, sram_tcm_data_outen=%b, sram_tcm_outputenable_n_out=%b, sram_tcm_write_n_out=%b, tcs0_grant=%b, tcs0_tcm_data_in=%h",
                         request, sram_tcm_address_out, sram_tcm_byteenable_n_out, sram_tcm_chipselect_n_out, sram_tcm_data_out, sram_tcm_data_outen, sram_tcm_outputenable_n_out, sram_tcm_write_n_out, tcs0_grant, tcs0_tcm_data_in);
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
        $dumpvars(0,clk, grant, reset, sram_tcm_data_in, tcs0_request, tcs0_tcm_address_out, tcs0_tcm_byteenable_n_out, tcs0_tcm_chipselect_n_out, tcs0_tcm_data_out, tcs0_tcm_data_outen, tcs0_tcm_outputenable_n_out, tcs0_tcm_write_n_out, request, sram_tcm_address_out, sram_tcm_byteenable_n_out, sram_tcm_chipselect_n_out, sram_tcm_data_out, sram_tcm_data_outen, sram_tcm_outputenable_n_out, sram_tcm_write_n_out, tcs0_grant, tcs0_tcm_data_in);
    end

endmodule
