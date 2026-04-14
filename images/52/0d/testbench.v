`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] BUTTONS;
    reg CLK_125MHZ_FPGA;
    reg [1:0] SWITCHES;
    wire [5:0] LEDS;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BUTTONS(BUTTONS),
        .CLK_125MHZ_FPGA(CLK_125MHZ_FPGA),
        .SWITCHES(SWITCHES),
        .LEDS(LEDS)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All buttons released", test_num);
            BUTTONS = 4'b0000;
            SWITCHES = 2'b00;
            #1;

            check_outputs(6'b000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Buttons 0 and 1 pressed (a=1, b=0)", test_num);
            BUTTONS = 4'b0011;
            SWITCHES = 2'b00;
            #1;

            check_outputs(6'b000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Buttons 2 and 3 pressed (a=0, b=1)", test_num);
            BUTTONS = 4'b1100;
            SWITCHES = 2'b00;
            #1;

            check_outputs(6'b000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: All four buttons pressed (a=1, b=1)", test_num);
            BUTTONS = 4'b1111;
            SWITCHES = 2'b00;
            #1;

            check_outputs(6'b000010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Three buttons pressed (1110)", test_num);
            BUTTONS = 4'b1110;
            SWITCHES = 2'b11;
            #1;

            check_outputs(6'b000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Verify non-target LEDs (0, 2-5) are low during trigger", test_num);
            BUTTONS = 4'b1111;
            SWITCHES = 2'b01;
            #1;

            check_outputs(6'b000010);
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
        input [5:0] expected_LEDS;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_LEDS === (expected_LEDS ^ LEDS ^ expected_LEDS)) begin
                $display("PASS");
                $display("  Outputs: LEDS=%h",
                         LEDS);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LEDS=%h",
                         expected_LEDS);
                $display("  Got:      LEDS=%h",
                         LEDS);
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

endmodule
