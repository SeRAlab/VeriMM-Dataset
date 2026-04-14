`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr;
    reg clk;
    reg [15:0] data;
    reg reset;
    reg we;
    wire [127:0] buffer;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data(data),
        .reset(reset),
        .we(we),
        .buffer(buffer)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        data = 16'h0;
        addr = 3'b0;
        we = 0;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Power-on Reset Check", test_num);
        reset_dut();

        #1;


        check_outputs(128'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single Write to Address 0", test_num);
        reset_dut();
        @(posedge clk);
        addr = 3'd0;
        data = 16'hAAAA;
        we = 1;
        @(negedge clk);
        #1 we = 0;
        @(posedge clk);
        #1;

        check_outputs({112'h0, 16'hAAAA});
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Test %0d: Fill All 8 Sections", test_num);
        reset_dut();
        for(i = 0; i < 8; i = i + 1) begin
            @(posedge clk);
            addr = i[2:0];
            data = 16'h1111 * (i + 1);
            we = 1;
            @(negedge clk);
            #1;
        end
        we = 0;
        @(posedge clk);
        #1;

        check_outputs(128'h88887777666655554444333322221111);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Write-Enable (WE=0) Check", test_num);
        reset_dut();
        @(posedge clk);
        addr = 3'd4;
        data = 16'hFFFF;
        we = 0;
        @(negedge clk);
        @(posedge clk);
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Overwrite Check at Address 7", test_num);
        reset_dut();

        @(posedge clk);
        addr = 3'd7; data = 16'h1234; we = 1;
        @(negedge clk);

        @(posedge clk);
        addr = 3'd7; data = 16'hABCD; we = 1;
        @(negedge clk);
        #1 we = 0;
        @(posedge clk);
        #1;

        check_outputs({16'hABCD, 112'h0});
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
        input [127:0] expected_buffer;
        begin
            if (expected_buffer === (expected_buffer ^ buffer ^ expected_buffer)) begin
                $display("PASS");
                $display("  Outputs: buffer=%h",
                         buffer);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: buffer=%h",
                         expected_buffer);
                $display("  Got:      buffer=%h",
                         buffer);
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
        $dumpvars(0,addr, clk, data, reset, we, buffer);
    end

endmodule
