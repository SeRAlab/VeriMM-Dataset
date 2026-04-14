`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    reg [7:0] updi;
    reg upen;
    reg uprs;
    reg upws;
    wire [7:0] cfg_out;
    wire upack;
    wire [7:0] updo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst_n(rst_n),
        .updi(updi),
        .upen(upen),
        .uprs(uprs),
        .upws(upws),
        .cfg_out(cfg_out),
        .upack(upack),
        .updo(updo)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            upen = 0;
            upws = 0;
            uprs = 0;
            updi = 8'h00;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Reset State");
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Basic Write 0xA5");
            reset_dut();
            @(posedge clk);
            updi = 8'hA5;
            upen = 1;
            upws = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5, 1'b1, 8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Write with upen=0");
            reset_dut();
            @(posedge clk);
            updi = 8'h55;
            upen = 0;
            upws = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 1'b0, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Write with upws=0");
            reset_dut();
            @(posedge clk);
            updi = 8'hFF;
            upen = 1;
            upws = 0;
            uprs = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00, 1'b0, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Read Operation");
            reset_dut();

            @(posedge clk);
            updi = 8'h3C;
            upen = 1;
            upws = 1;
            @(posedge clk);
            #1;

            upws = 0;
            uprs = 1;
            #1;

            #1;


            check_outputs(8'h3C, 1'b1, 8'h3C);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Data Retention after Disable");
            reset_dut();
            @(posedge clk);
            updi = 8'h77;
            upen = 1;
            upws = 1;
            @(posedge clk);
            #1;
            upen = 0;
            upws = 0;
            updi = 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h77, 1'b0, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Sequential Writes");
            reset_dut();
            upen = 1;
            upws = 1;
            updi = 8'h11;
            @(posedge clk);
            #1;
            updi = 8'h22;
            @(posedge clk);
            #1;
            updi = 8'h33;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h33, 1'b1, 8'h33);
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
        input [7:0] expected_cfg_out;
        input expected_upack;
        input [7:0] expected_updo;
        begin
            if (expected_cfg_out === (expected_cfg_out ^ cfg_out ^ expected_cfg_out) &&
                expected_upack === (expected_upack ^ upack ^ expected_upack) &&
                expected_updo === (expected_updo ^ updo ^ expected_updo)) begin
                $display("PASS");
                $display("  Outputs: cfg_out=%h, upack=%b, updo=%h",
                         cfg_out, upack, updo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cfg_out=%h, upack=%b, updo=%h",
                         expected_cfg_out, expected_upack, expected_updo);
                $display("  Got:      cfg_out=%h, upack=%b, updo=%h",
                         cfg_out, upack, updo);
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
        $dumpvars(0,clk, rst_n, updi, upen, uprs, upws, cfg_out, upack, updo);
    end

endmodule
