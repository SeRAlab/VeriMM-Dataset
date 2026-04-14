`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    wire [7:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .s(s)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            d = 0;
            force dut.s = 0;
            @(posedge clk);
            #1;
            release dut.s;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            d = 8'd10;
            @(posedge clk);
            d = 8'd25;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd35);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            repeat(10) begin
                d = 8'd1;
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            d = 8'd250;
            @(posedge clk);
            d = 8'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            d = 8'd42;
            @(posedge clk);
            d = 8'd0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd42);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            d = 8'hFF;
            @(posedge clk);
            d = 8'h01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            d = 8'd5;  @(posedge clk);
            d = 8'd15; @(posedge clk);
            d = 8'd30; @(posedge clk);
            d = 8'd50; @(posedge clk);
            #1;
            #1;

            check_outputs(8'd100);
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
        input [7:0] expected_s;
        begin
            if (expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: s=%h",
                         s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s=%h",
                         expected_s);
                $display("  Got:      s=%h",
                         s);
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
        $dumpvars(0,clk, d, s);
    end

endmodule
