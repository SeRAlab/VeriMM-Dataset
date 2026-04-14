`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] LED0;
    reg [6:0] LED1;
    reg [6:0] LED2;
    reg [6:0] LED3;
    reg clk;
    reg rst;
    wire [6:0] LEDOUT;
    wire [3:0] LEDSEL;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .LED0(LED0),
        .LED1(LED1),
        .LED2(LED2),
        .LED3(LED3),
        .clk(clk),
        .rst(rst),
        .LEDOUT(LEDOUT),
        .LEDSEL(LEDSEL)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            LED0 = 7'h3F;
            LED1 = 7'h06;
            LED2 = 7'h5B;
            LED3 = 7'h4F;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset State (LED0)");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(7'h3F, 4'b0001);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Next State (LED1)");
            test_num = 2;
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'h06, 4'b0010);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Third State (LED2)");
            test_num = 3;
            reset_dut();
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(7'h5B, 4'b0100);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Fourth State (LED3)");
            test_num = 4;
            reset_dut();
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(7'h4F, 4'b1000);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Wrap-around (Back to LED0)");
            test_num = 5;
            reset_dut();
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(7'h3F, 4'b0001);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Data Change Verification");
            test_num = 6;
            reset_dut();

            LED2 = 7'h7F;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(7'h7F, 4'b0100);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Long Cycle Test (Index 3)");
            test_num = 7;
            reset_dut();
            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(7'h4F, 4'b1000);
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
        input [6:0] expected_LEDOUT;
        input [3:0] expected_LEDSEL;
        begin
            if (expected_LEDOUT === (expected_LEDOUT ^ LEDOUT ^ expected_LEDOUT) &&
                expected_LEDSEL === (expected_LEDSEL ^ LEDSEL ^ expected_LEDSEL)) begin
                $display("PASS");
                $display("  Outputs: LEDOUT=%h, LEDSEL=%h",
                         LEDOUT, LEDSEL);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LEDOUT=%h, LEDSEL=%h",
                         expected_LEDOUT, expected_LEDSEL);
                $display("  Got:      LEDOUT=%h, LEDSEL=%h",
                         LEDOUT, LEDSEL);
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
        $dumpvars(0,LED0, LED1, LED2, LED3, clk, rst, LEDOUT, LEDSEL);
    end

endmodule
