`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d1;
    reg [7:0] d2;
    reg sel;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d1(d1),
        .d2(d2),
        .sel(sel),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            d1 = 8'h00;
            d2 = 8'h00;
            sel = 0;
            @(negedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            d1 = 8'hA5;
            d2 = 8'h5A;
            sel = 0;
            @(negedge clk);
            #1;
            $display("Testcase 001: Select d1 (0xA5)");
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            d1 = 8'hA5;
            d2 = 8'h5A;
            sel = 1;
            @(negedge clk);
            #1;
            $display("Testcase 002: Select d2 (0x5A)");
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            d1 = 8'hFF;
            d2 = 8'h00;
            sel = 0;
            @(negedge clk);
            #1;
            $display("Testcase 003: Select d1 All Ones (0xFF)");
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            d1 = 8'hFF;
            d2 = 8'h00;
            sel = 1;
            @(negedge clk);
            #1;
            $display("Testcase 004: Select d2 All Zeros (0x00)");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            d1 = 8'h44;
            sel = 0;
            @(posedge clk);
            #1;
            if (q !== 8'h00) begin
                $display("FAIL: Data changed on positive edge!");
            end
            @(negedge clk);
            #1;
            $display("Testcase 005: Negedge sensitivity check");
            #1;

            check_outputs(8'h44);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            d1 = 8'h11;
            d2 = 8'h22;
            sel = 0;
            #2;
            sel = 1;
            @(negedge clk);
            #1;
            $display("Testcase 006: Dynamic select switch before edge");
            #1;

            check_outputs(8'h22);
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
        input [7:0] expected_q;
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
        $dumpvars(0,clk, d1, d2, sel, q);
    end

endmodule
