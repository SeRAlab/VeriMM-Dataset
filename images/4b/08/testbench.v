`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [47:0] data;
    reg en;
    reg reset;
    reg sclk_negedge;
    reg sclk_posedge;
    wire done;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .en(en),
        .reset(reset),
        .sclk_negedge(sclk_negedge),
        .sclk_posedge(sclk_posedge),
        .done(done),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            en = 0;
            data = 0;
            sclk_posedge = 0;
            sclk_negedge = 0;
            repeat(2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task pulse_sclk;

        begin
            repeat(5) @(posedge clk);
            sclk_posedge = 1;
            @(posedge clk);
            sclk_posedge = 0;
            repeat(5) @(posedge clk);
            sclk_negedge = 1;
            @(posedge clk);
            sclk_negedge = 0;
        end
        endtask

    task testcase001;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transmitting 48'h000000000000", test_num);
            reset_dut();
            data = 48'h0000_0000_0000;
            en = 1;
            @(posedge clk);
            en = 0;



            for (i = 0; i < 60; i = i + 1) begin
                pulse_sclk();
                if (done) break;
            end


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transmitting 48'hFFFFFFFFFFFF", test_num);
            reset_dut();
            data = 48'hFFFF_FFFF_FFFF;
            en = 1;
            @(posedge clk);
            en = 0;

            for (i = 0; i < 60; i = i + 1) begin
                pulse_sclk();
                if (done) break;
            end


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transmitting 48'hAAAA_AAAA_AAAA (LSB is 0)", test_num);
            reset_dut();
            data = 48'hAAAA_AAAA_AAAA;
            en = 1;
            @(posedge clk);
            en = 0;

            for (i = 0; i < 60; i = i + 1) begin
                pulse_sclk();
                if (done) break;
            end


            #1;



            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transmitting 48'h1234_5678_9ABC (LSB is 0)", test_num);
            reset_dut();
            data = 48'h1234_5678_9ABC;
            en = 1;
            @(posedge clk);
            en = 0;

            for (i = 0; i < 60; i = i + 1) begin
                pulse_sclk();
                if (done) break;
            end


            #1;



            check_outputs(1'b1, 1'b0);
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
        input expected_done;
        input expected_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, out=%b",
                         done, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, out=%b",
                         expected_done, expected_out);
                $display("  Got:      done=%b, out=%b",
                         done, out);
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
        $dumpvars(0,clk, data, en, reset, sclk_negedge, sclk_posedge, done, out);
    end

endmodule
