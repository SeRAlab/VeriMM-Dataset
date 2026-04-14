`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_CLK;
    reg i_RST;
    reg i_SDI;
    wire [7:0] o_LED;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_CLK(i_CLK),
        .i_RST(i_RST),
        .i_SDI(i_SDI),
        .o_LED(o_LED)
    );

        task reset_dut;

        begin
            i_RST = 1;
            i_SDI = 0;
            repeat(8) @(posedge i_CLK);
            i_RST = 0;
            @(posedge i_CLK);
        end
        endtask
    task testcase001;

        integer i;
        begin
            $display("Test Case 001: Fast Shift All Ones (0xFF)");
            test_num = test_num + 1;
            reset_dut();

            i_RST = 1;
            for (i = 0; i < 8; i = i + 1) begin
                i_SDI = 1;
                @(posedge i_CLK);
            end
            i_RST = 0;
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase002;

        reg [7:0] pattern;
        integer i;
        begin
            $display("Test Case 002: Fast Shift Pattern 0xAA (10101010)");
            test_num = test_num + 1;
            reset_dut();

            pattern = 8'hAA;
            i_RST = 1;
            for (i = 7; i >= 0; i = i - 1) begin
                i_SDI = pattern[i];
                @(posedge i_CLK);
            end
            i_RST = 0;
            #2;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        reg [7:0] pattern;
        integer i;
        begin
            $display("Test Case 003: Fast Shift Pattern 0x55 (01010101)");
            test_num = test_num + 1;
            reset_dut();

            pattern = 8'h55;
            i_RST = 1;
            for (i = 7; i >= 0; i = i - 1) begin
                i_SDI = pattern[i];
                @(posedge i_CLK);
            end
            i_RST = 0;
            #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        reg [7:0] pattern;
        integer i;
        begin
            $display("Test Case 004: Fast Shift Pattern 0x0F (00001111)");
            test_num = test_num + 1;
            reset_dut();

            pattern = 8'h0F;
            i_RST = 1;
            for (i = 7; i >= 0; i = i - 1) begin
                i_SDI = pattern[i];
                @(posedge i_CLK);
            end
            i_RST = 0;
            #2;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Stability Check (No fast shift when i_RST=0)");
            test_num = test_num + 1;
            reset_dut();

            i_RST = 0;
            i_SDI = 1;

            repeat(100) @(posedge i_CLK);

            #1;


            check_outputs(8'h00);
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
        input [7:0] expected_o_LED;
        begin
            if (expected_o_LED === (expected_o_LED ^ o_LED ^ expected_o_LED)) begin
                $display("PASS");
                $display("  Outputs: o_LED=%h",
                         o_LED);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_LED=%h",
                         expected_o_LED);
                $display("  Got:      o_LED=%h",
                         o_LED);
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
        $dumpvars(0,i_CLK, i_RST, i_SDI, o_LED);
    end

endmodule
