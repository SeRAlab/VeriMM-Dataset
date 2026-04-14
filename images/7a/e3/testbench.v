`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg EN;
    reg PRESET;
    reg [31:0] PRESET_VAL;
    reg RST;
    wire ZERO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .EN(EN),
        .PRESET(PRESET),
        .PRESET_VAL(PRESET_VAL),
        .RST(RST),
        .ZERO(ZERO)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            EN = 0;
            PRESET = 0;
            PRESET_VAL = 32'h0;
            @(posedge CLK);
            #1 RST = 0;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Reset", test_num);
            reset_dut();
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Preset to non-zero", test_num);
            reset_dut();
            PRESET_VAL = 32'd10;
            PRESET = 1;
            @(posedge CLK);
            #1 PRESET = 0;
            @(posedge CLK);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Countdown to zero", test_num);
            reset_dut();
            PRESET_VAL = 32'd5;
            PRESET = 1;
            @(posedge CLK);
            #1 PRESET = 0;
            EN = 1;
            repeat (5) @(posedge CLK);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Enable/Disable behavior", test_num);
            reset_dut();
            PRESET_VAL = 32'd5;
            PRESET = 1;
            @(posedge CLK);
            #1 PRESET = 0;
            EN = 1;
            repeat (2) @(posedge CLK);
            #1 EN = 0;
            repeat (2) @(posedge CLK);
            #1 EN = 1;
            repeat (3) @(posedge CLK);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Preset while running", test_num);
            reset_dut();
            PRESET_VAL = 32'd10;
            PRESET = 1;
            @(posedge CLK);
            #1 PRESET = 0;
            EN = 1;
            repeat (5) @(posedge CLK);
            #1 PRESET_VAL = 32'd2;
            PRESET = 1;
            @(posedge CLK);
            #1 PRESET = 0;
            repeat (2) @(posedge CLK);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();
            PRESET_VAL = 32'd100;
            PRESET = 1;
            @(posedge CLK);
            #1 PRESET = 0;
            EN = 1;
            repeat (10) @(posedge CLK);
            #1 RST = 1;
            @(posedge CLK);
            #1 RST = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Short countdown from large value", test_num);
            reset_dut();
            PRESET_VAL = 32'h0000_000F;
            PRESET = 1;
            @(posedge CLK);
            #1 PRESET = 0;
            EN = 1;
            repeat (14) @(posedge CLK);
            #1 #1;
 check_outputs(1'b0);
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
        input expected_ZERO;
        begin
            if (expected_ZERO === (expected_ZERO ^ ZERO ^ expected_ZERO)) begin
                $display("PASS");
                $display("  Outputs: ZERO=%b",
                         ZERO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ZERO=%b",
                         expected_ZERO);
                $display("  Got:      ZERO=%b",
                         ZERO);
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
        $dumpvars(0,CLK, EN, PRESET, PRESET_VAL, RST, ZERO);
    end

endmodule
