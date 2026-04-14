`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] cin;
    reg clk;
    reg en;
    reg load;
    reg nrst;
    reg [7:0] step;
    wire [7:0] cnt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cin(cin),
        .clk(clk),
        .en(en),
        .load(load),
        .nrst(nrst),
        .step(step),
        .cnt(cnt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            nrst = 0;
            en = 0;
            load = 0;
            step = 0;
            cin = 0;
            @(posedge clk);
            #1;
            nrst = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Check");
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Load Operation");
            reset_dut();
            cin = 8'hA5;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Simple Increment (Step=1)");
            reset_dut();
            en = 1;
            step = 8'h01;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Configurable Step (Step=5)");
            reset_dut();
            en = 1;
            step = 8'h05;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Enable Signal Check (en=0)");
            reset_dut();
            en = 0;
            step = 8'h01;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Load Priority Check");
            reset_dut();

            en = 1;
            step = 8'h01;
            @(posedge clk);


            cin = 8'h55;
            load = 1;
            step = 8'h0A;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Wrap-around Check");
            reset_dut();

            cin = 8'hFE;
            load = 1;
            @(posedge clk);
            load = 0;


            en = 1;
            step = 8'h03;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Load then Count Sequence");
            reset_dut();

            cin = 8'd10;
            load = 1;
            @(posedge clk);
            load = 0;


            en = 1;
            step = 8'd2;
            repeat(4) @(posedge clk);

            #1;
            #1;

            check_outputs(8'd18);
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
        input [7:0] expected_cnt;
        begin
            if (expected_cnt === (expected_cnt ^ cnt ^ expected_cnt)) begin
                $display("PASS");
                $display("  Outputs: cnt=%h",
                         cnt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cnt=%h",
                         expected_cnt);
                $display("  Got:      cnt=%h",
                         cnt);
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
        $dumpvars(0,cin, clk, en, load, nrst, step, cnt);
    end

endmodule
