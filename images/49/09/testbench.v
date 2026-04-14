`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] enable;
    reg [31:0] value;
    wire [7:0] SSEG_AN;
    wire [7:0] SSEG_CA;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .value(value),
        .SSEG_AN(SSEG_AN),
        .SSEG_CA(SSEG_CA)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 8'h00;
            value = 32'h0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        integer i;
        reg found;
        begin
            reset_dut();
            test_num = test_num + 1;
            value = 32'hBA785630;
            enable = 8'hFF;
            found = 0;
            $display("Running testcase001: Checking Digit 0 (Value 0)");
            for (i = 0; i < 16; i = i + 1) begin
                if (SSEG_AN === 8'hFE) begin
                    found = 1;
                    #1;
                    #1;

                    check_outputs(8'hFE, 8'hC0);
                end
                if (found) break;
                @(posedge clk);
            end
            if (!found) begin
                $display("FAIL: Could not synchronize to Digit 0 Anode (8'hFE)");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase002;

        integer i;
        reg found;
        begin
            reset_dut();
            test_num = test_num + 1;
            value = 32'hBA785630;
            enable = 8'hFF;
            found = 0;
            $display("Running testcase002: Checking Digit 1 (Value 3)");
            for (i = 0; i < 16; i = i + 1) begin
                if (SSEG_AN === 8'hFD) begin
                    found = 1;
                    #1;
                    #1;

                    check_outputs(8'hFD, 8'hB0);
                end
                if (found) break;
                @(posedge clk);
            end
            if (!found) begin
                $display("FAIL: Could not synchronize to Digit 1 Anode (8'hFD)");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase003;

        integer i;
        reg found;
        begin
            reset_dut();
            test_num = test_num + 1;
            value = 32'hBA785630;
            enable = 8'hFF;
            found = 0;
            $display("Running testcase003: Checking Digit 7 (Value B)");
            for (i = 0; i < 16; i = i + 1) begin
                if (SSEG_AN === 8'h7F) begin
                    found = 1;
                    #1;
                    #1;

                    check_outputs(8'h7F, 8'h83);
                end
                if (found) break;
                @(posedge clk);
            end
            if (!found) begin
                $display("FAIL: Could not synchronize to Digit 7 Anode (8'h7F)");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        integer i;
        reg found;
        begin
            reset_dut();
            test_num = test_num + 1;
            value = 32'hBA785630;
            enable = 8'hFF;
            found = 0;
            $display("Running testcase004: Checking Digit 6 (Value A)");
            for (i = 0; i < 16; i = i + 1) begin
                if (SSEG_AN === 8'hBF) begin
                    found = 1;
                    #1;
                    #1;

                    check_outputs(8'hBF, 8'h88);
                end
                if (found) break;
                @(posedge clk);
            end
            if (!found) begin
                $display("FAIL: Could not synchronize to Digit 6 Anode (8'hBF)");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        integer i;
        reg found;
        begin
            reset_dut();
            test_num = test_num + 1;
            value = 32'hBA785630;
            enable = 8'hEF;
            found = 0;
            $display("Running testcase005: Checking Digit 4 (Disabled)");

            for (i = 0; i < 16; i = i + 1) begin
                if (SSEG_AN === 8'hF7) begin
                    @(posedge clk);
                    #1;
                    #1;

                    check_outputs(8'hFF, SSEG_CA);
                    found = 1;
                end
                if (found) break;
                @(posedge clk);
            end
            if (!found) begin
                $display("FAIL: Could not synchronize to test slot");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            value = 32'hFFFFFFFF;
            enable = 8'h00;
            $display("Running testcase006: All Digits Disabled");
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF, SSEG_CA);
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
        input [7:0] expected_SSEG_AN;
        input [7:0] expected_SSEG_CA;
        begin
            if (expected_SSEG_AN === (expected_SSEG_AN ^ SSEG_AN ^ expected_SSEG_AN) &&
                expected_SSEG_CA === (expected_SSEG_CA ^ SSEG_CA ^ expected_SSEG_CA)) begin
                $display("PASS");
                $display("  Outputs: SSEG_AN=%h, SSEG_CA=%h",
                         SSEG_AN, SSEG_CA);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SSEG_AN=%h, SSEG_CA=%h",
                         expected_SSEG_AN, expected_SSEG_CA);
                $display("  Got:      SSEG_AN=%h, SSEG_CA=%h",
                         SSEG_AN, SSEG_CA);
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
        $dumpvars(0,clk, enable, value, SSEG_AN, SSEG_CA);
    end

endmodule
