`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] amount;
    reg clk;
    reg clr;
    reg [63:0] data;
    reg ena;
    reg load;
    wire [63:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .amount(amount),
        .clk(clk),
        .clr(clr),
        .data(data),
        .ena(ena),
        .load(load),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 1;
            load = 0;
            ena = 0;
            amount = 0;
            data = 0;
            @(posedge clk);
            #1 clr = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Synchronous Load", test_num);
            data = 64'hFEDCBA9876543210;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(64'hFEDCBA9876543210);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Shift Left 1 bit", test_num);

            data = 64'h0000000000000001;
            load = 1;
            @(posedge clk);
            #1 load = 0;

            ena = 1;
            amount = 2'b00;
            @(posedge clk);
            #1 ena = 0;
            #1;

            check_outputs(64'h0000000000000002);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Shift Left 4 bits", test_num);
            data = 64'h000000000000000F;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            ena = 1;
            amount = 2'b01;
            @(posedge clk);
            #1 ena = 0;
            #1;

            check_outputs(64'h00000000000000F0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Arithmetic Shift Right 1 (Positive)", test_num);
            data = 64'h7000000000000000;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            ena = 1;
            amount = 2'b10;
            @(posedge clk);
            #1 ena = 0;
            #1;

            check_outputs(64'h3800000000000000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Arithmetic Shift Right 1 (Negative - Sign Ext)", test_num);
            data = 64'h8000000000000000;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            ena = 1;
            amount = 2'b10;
            @(posedge clk);
            #1 ena = 0;

            #1;


            check_outputs(64'hC000000000000000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Arithmetic Shift Right 4 (Negative)", test_num);
            data = 64'hF000000000000000;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            ena = 1;
            amount = 2'b11;
            @(posedge clk);
            #1 ena = 0;
            #1;

            check_outputs(64'hFF00000000000000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Enable signal check (Hold value)", test_num);
            data = 64'hAAAA_BBBB_CCCC_DDDD;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            ena = 0;
            amount = 2'b00;
            @(posedge clk);
            #1;

            check_outputs(64'hAAAA_BBBB_CCCC_DDDD);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase %0d: Synchronous Clear Check", test_num);
            data = 64'hFFFF_FFFF_FFFF_FFFF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            clr = 1;
            @(posedge clk);
            #1 clr = 0;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            $display("Testcase %0d: Priority Check (CLR vs LOAD)", test_num);
            data = 64'h5555_5555_5555_5555;
            load = 1;
            clr = 1;
            @(posedge clk);
            #1 clr = 0; load = 0;
            #1;

            check_outputs(64'h0);
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
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [63:0] expected_q;
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
        $dumpvars(0,amount, clk, clr, data, ena, load, q);
    end

endmodule
