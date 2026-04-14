`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg loadseed_i;
    reg resetn;
    reg [31:0] seed_i;
    wire [31:0] number_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .loadseed_i(loadseed_i),
        .resetn(resetn),
        .seed_i(seed_i),
        .number_o(number_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetn = 0;
            en = 0;
            loadseed_i = 0;
            seed_i = 32'h0;
            repeat(2) @(posedge clk);
            #1;
            resetn = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verify Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verify Seed Loading", test_num);
            reset_dut();
            seed_i = 32'hACE1FACE;
            loadseed_i = 1;
            @(posedge clk);
            #1;
            loadseed_i = 0;
            #1;

            check_outputs(32'hACE1FACE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verify Output Stability when en=0", test_num);
            reset_dut();
            seed_i = 32'h12345678;
            loadseed_i = 1;
            @(posedge clk);
            #1;
            loadseed_i = 0;
            en = 0;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        reg [31:0] first_gen;
        begin
            test_num = 4;
            $display("Testcase %0d: Verify Advancement when en=1", test_num);
            reset_dut();
            seed_i = 32'hA5A5A5A5;
            loadseed_i = 1;
            @(posedge clk);
            #1;
            loadseed_i = 0;
            en = 1;
            @(posedge clk);
            #1;
            en = 0;

            if (number_o != 32'hA5A5A5A5 && number_o != 32'h0) begin
                $display("PASS: Random number generated (New Value: %h)", number_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Random number did not advance or reset unexpectedly");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verify Reset Override", test_num);
            reset_dut();
            seed_i = 32'hFFFFFFFF;
            loadseed_i = 1;
            @(posedge clk);
            #1;
            loadseed_i = 0;
            en = 1;
            repeat(3) @(posedge clk);
            resetn = 0;
            @(posedge clk);
            #1;
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
        input [31:0] expected_number_o;
        begin
            if (expected_number_o === (expected_number_o ^ number_o ^ expected_number_o)) begin
                $display("PASS");
                $display("  Outputs: number_o=%h",
                         number_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: number_o=%h",
                         expected_number_o);
                $display("  Got:      number_o=%h",
                         number_o);
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
        $dumpvars(0,clk, en, loadseed_i, resetn, seed_i, number_o);
    end

endmodule
