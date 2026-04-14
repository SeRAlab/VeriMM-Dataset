`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] data;
    reg pclk;
    wire [15:0] rgb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .pclk(pclk),
        .rgb(rgb)
    );

    // Clock generation (10ns period)
    initial begin
        pclk = 0;
        forever #5 pclk = ~pclk;
    end

        task reset_dut;

    begin
        data <= 8'h01;
        @(posedge pclk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Testing White (Input 0xFF)", test_num);
        reset_dut();
        data <= 8'hFF;
        @(posedge pclk);
        #1;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Testing Red (Input 0xF0)", test_num);
        reset_dut();
        data <= 8'hF0;
        @(posedge pclk);
        #1;
        #1;

        check_outputs(16'hF800);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Testing Green (Input 0x0F)", test_num);
        reset_dut();
        data <= 8'h0F;
        @(posedge pclk);
        #1;
        #1;

        check_outputs(16'h07E0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Testing Blue (Input 0x00)", test_num);
        reset_dut();
        data <= 8'h00;
        @(posedge pclk);
        #1;
        #1;

        check_outputs(16'h001F);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Testing Default/Black (Input 0x55)", test_num);
        reset_dut();
        data <= 8'h55;
        @(posedge pclk);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Testing Default/Black (Input 0xAA)", test_num);
        reset_dut();
        data <= 8'hAA;
        @(posedge pclk);
        #1;
        #1;

        check_outputs(16'h0000);
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
        input [15:0] expected_rgb;
        begin
            if (expected_rgb === (expected_rgb ^ rgb ^ expected_rgb)) begin
                $display("PASS");
                $display("  Outputs: rgb=%h",
                         rgb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rgb=%h",
                         expected_rgb);
                $display("  Got:      rgb=%h",
                         rgb);
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
        $dumpvars(0,data, pclk, rgb);
    end

endmodule
