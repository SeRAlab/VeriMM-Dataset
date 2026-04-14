`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg osc_clk;
    reg rstn;
    wire clk;
    wire [7:0] led;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .osc_clk(osc_clk),
        .rstn(rstn),
        .clk(clk),
        .led(led)
    );

    // Clock generation (10ns period)
    initial begin
        osc_clk = 0;
        forever #5 osc_clk = ~osc_clk;
    end

        task reset_dut;

        begin
            rstn = 0;
            #100;
            @(posedge osc_clk);
            rstn = 1;
            @(posedge osc_clk);
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase 001: Reset Check");
            reset_dut();

            #1;


            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase 002: First Gray Increment");
            reset_dut();

            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase 003: Second Gray Increment");
            reset_dut();

            @(posedge clk);
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 8'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase 004: Third Gray Increment");
            reset_dut();

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 8'h02);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase 005: Fourth Gray Increment");
            reset_dut();

            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 8'h06);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase 006: Mid-operation Reset");
            reset_dut();

            @(posedge clk);
            @(posedge clk);
            #10;


            rstn = 0;
            #100;


            #1;



            check_outputs(1'b0, 8'h00);
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
        input expected_clk;
        input [7:0] expected_led;
        begin
            if (expected_clk === (expected_clk ^ clk ^ expected_clk) &&
                expected_led === (expected_led ^ led ^ expected_led)) begin
                $display("PASS");
                $display("  Outputs: clk=%b, led=%h",
                         clk, led);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk=%b, led=%h",
                         expected_clk, expected_led);
                $display("  Got:      clk=%b, led=%h",
                         clk, led);
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
        $dumpvars(0,osc_clk, rstn, clk, led);
    end

endmodule
