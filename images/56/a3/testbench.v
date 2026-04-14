`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg arst;
    reg clk;
    reg [7:0] d;
    reg en;
    reg ld;
    reg srst;
    wire lz;
    wire [7:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .arst(arst),
        .clk(clk),
        .d(d),
        .en(en),
        .ld(ld),
        .srst(srst),
        .lz(lz),
        .z(z)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            arst = 1;
            srst = 0;
            en = 0;
            ld = 0;
            d = 0;
            #15;
            arst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset State Check");
            reset_dut();
            test_num = 1;

            #1;


            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Load (Bitwise Negation)");
            reset_dut();
            test_num = 2;
            en = 1;
            ld = 1;
            d = 8'hAA;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'h55);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Subtraction");
            reset_dut();
            test_num = 3;

            en = 1; ld = 1; d = 8'h0F;
            @(posedge clk);

            #1; en = 1; ld = 0; d = 8'h10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'hE0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Zero Flag via Load");
            reset_dut();
            test_num = 4;

            en = 1; ld = 1; d = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Zero Flag via Subtraction");
            reset_dut();
            test_num = 5;

            en = 1; ld = 1; d = 8'hFE;
            @(posedge clk);

            #1; en = 1; ld = 0; d = 8'h01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Synchronous Reset");
            reset_dut();
            test_num = 6;
            en = 1; ld = 1; d = 8'hAA;
            @(posedge clk);
            #1;
            srst = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'h00);
            srst = 0;
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Enable Signal");
            reset_dut();
            test_num = 7;
            en = 1; ld = 1; d = 8'hAA;
            @(posedge clk);
            #1;
            en = 0; ld = 0; d = 8'h05;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'h55);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase 008: Underflow Subtraction");
            reset_dut();
            test_num = 8;
            en = 1; ld = 1; d = 8'hFF;
            @(posedge clk);
            #1;
            en = 1; ld = 0; d = 8'h01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'hFF);
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
        input expected_lz;
        input [7:0] expected_z;
        begin
            if (expected_lz === (expected_lz ^ lz ^ expected_lz) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: lz=%b, z=%h",
                         lz, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lz=%b, z=%h",
                         expected_lz, expected_z);
                $display("  Got:      lz=%b, z=%h",
                         lz, z);
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
        $dumpvars(0,arst, clk, d, en, ld, srst, lz, z);
    end

endmodule
