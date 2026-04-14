`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [8:0] led;
    reg rst;
    wire [2:0] leda;
    wire [10:0] ledc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .led(led),
        .rst(rst),
        .leda(leda),
        .ledc(ledc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            led = 9'b0;
            @(posedge clk);
            #2 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            led = 9'h1FF;

            @(posedge clk);
            #1;

            check_outputs(3'b110, 11'h1FF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            led = 9'h1FF;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(3'b101, 11'h1FF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            led = 9'h1FF;
            repeat(3) @(posedge clk);
            #1;

            check_outputs(3'b011, 11'h1FF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            led = 9'h0AA;
            repeat(4) @(posedge clk);
            #1;

            check_outputs(3'b110, 11'h0AA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            led = 9'h007;
            @(posedge clk);
            #1;

            check_outputs(3'b110, 11'h007);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            led = 9'h038;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(3'b101, 11'h038);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            led = 9'h000;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(3'b101, 11'h000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            @(posedge clk);
            @(posedge clk);

            rst = 1;
            @(posedge clk);
            rst = 0;
            led = 9'h155;
            @(posedge clk);
            #1;

            check_outputs(3'b110, 11'h155);
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
        input [2:0] expected_leda;
        input [10:0] expected_ledc;
        begin
            if (expected_leda === (expected_leda ^ leda ^ expected_leda) &&
                expected_ledc === (expected_ledc ^ ledc ^ expected_ledc)) begin
                $display("PASS");
                $display("  Outputs: leda=%h, ledc=%h",
                         leda, ledc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: leda=%h, ledc=%h",
                         expected_leda, expected_ledc);
                $display("  Got:      leda=%h, ledc=%h",
                         leda, ledc);
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
        $dumpvars(0,clk, led, rst, leda, ledc);
    end

endmodule
