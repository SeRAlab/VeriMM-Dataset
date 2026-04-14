`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] ra1;
    reg [4:0] ra2;
    reg [4:0] wa3;
    reg [31:0] wd3;
    reg we3;
    wire [31:0] rd1;
    wire [31:0] rd2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ra1(ra1),
        .ra2(ra2),
        .wa3(wa3),
        .wd3(wd3),
        .we3(we3),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ra1 = 0;
            ra2 = 0;
            wa3 = 0;
            wd3 = 0;
            we3 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;

            wa3 = 5'd1;
            wd3 = 32'hDEADBEEF;
            we3 = 1;
            @(posedge clk);
            #1;
            we3 = 0;
            ra1 = 5'd1;
            ra2 = 5'd1;
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;

            wa3 = 5'd0;
            wd3 = 32'hFFFFFFFF;
            we3 = 1;
            @(posedge clk);
            #1;
            we3 = 0;
            ra1 = 5'd0;
            ra2 = 5'd0;
            #1;
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            wa3 = 5'd2;
            wd3 = 32'hAAAA5555;
            we3 = 0;
            @(posedge clk);
            #1;
            ra1 = 5'd2;
            ra2 = 5'd2;
            #1;

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;

            wa3 = 5'd10;
            wd3 = 32'h12345678;
            we3 = 1;
            @(posedge clk);
            #1;

            wa3 = 5'd20;
            wd3 = 32'h87654321;
            we3 = 1;
            @(posedge clk);
            #1;
            we3 = 0;
            ra1 = 5'd10;
            ra2 = 5'd20;
            #1;
            #1;

            check_outputs(32'h12345678, 32'h87654321);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            wa3 = 5'd31;
            wd3 = 32'hF0F0F0F0;
            we3 = 1;
            @(posedge clk);
            #1;
            we3 = 0;
            ra1 = 5'd31;
            ra2 = 5'd0;
            #1;
            #1;

            check_outputs(32'hF0F0F0F0, 32'h00000000);
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
        input [31:0] expected_rd1;
        input [31:0] expected_rd2;
        begin
            if (expected_rd1 === (expected_rd1 ^ rd1 ^ expected_rd1) &&
                expected_rd2 === (expected_rd2 ^ rd2 ^ expected_rd2)) begin
                $display("PASS");
                $display("  Outputs: rd1=%h, rd2=%h",
                         rd1, rd2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd1=%h, rd2=%h",
                         expected_rd1, expected_rd2);
                $display("  Got:      rd1=%h, rd2=%h",
                         rd1, rd2);
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
        $dumpvars(0,clk, ra1, ra2, wa3, wd3, we3, rd1, rd2);
    end

endmodule
