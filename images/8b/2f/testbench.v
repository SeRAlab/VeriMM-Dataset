`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg b;
    reg clk;
    reg [7:0] data;
    reg edge_detect;
    reg reset;
    reg sel_b1;
    reg sel_b2;
    wire [15:0] led_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .data(data),
        .edge_detect(edge_detect),
        .reset(reset),
        .sel_b1(sel_b1),
        .sel_b2(sel_b2),
        .led_out(led_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            clk = 0;
            a = 0;
            b = 0;
            data = 8'h00;
            edge_detect = 0;
            sel_b1 = 0;
            sel_b2 = 0;
            #10;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 001: Update pattern1 and verify output (sel=00)");


            data = 8'hA5;
            edge_detect = 0;
            @(posedge clk);
            #1;

            sel_b2 = 0;
            sel_b1 = 0;
            #1;
            #1;

            check_outputs(16'hA500);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 002: Update pattern2 and verify output (sel=01)");


            data = 8'h3C;
            edge_detect = 1;
            @(posedge clk);
            #1;

            sel_b2 = 0;
            sel_b1 = 1;
            #1;
            #1;

            check_outputs(16'h3C00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 003: Verify selection for bit 'a' (sel=10)");

            a = 1;
            sel_b2 = 1;
            sel_b1 = 0;
            #5;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 004: Verify selection for bit 'b' (sel=11)");

            b = 1;
            sel_b2 = 1;
            sel_b1 = 1;
            #5;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 005: Sequential updates and persistence");


            data = 8'hAA;
            edge_detect = 0;
            @(posedge clk);
            #1;


            data = 8'h55;
            edge_detect = 1;
            @(posedge clk);
            #1;


            sel_b2 = 0; sel_b1 = 0;
            #5;
            #1;

            check_outputs(16'hAA00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 006: Verify edge_detect isolation");


            data = 8'hF0;
            edge_detect = 0;
            @(posedge clk);
            #1;


            data = 8'h0F;
            edge_detect = 1;
            @(posedge clk);
            #1;


            sel_b2 = 0; sel_b1 = 1;
            #5;
            #1;

            check_outputs(16'h0F00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 007: Verify reset clears registers");


            data = 8'hFF;
            edge_detect = 0;
            @(posedge clk);
            #1;


            reset = 1;
            #20;
            reset = 0;
            #10;

            sel_b2 = 0; sel_b1 = 0;
            #5;
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
        input [15:0] expected_led_out;
        begin
            if (expected_led_out === (expected_led_out ^ led_out ^ expected_led_out)) begin
                $display("PASS");
                $display("  Outputs: led_out=%h",
                         led_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led_out=%h",
                         expected_led_out);
                $display("  Got:      led_out=%h",
                         led_out);
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
        $dumpvars(0,a, b, clk, data, edge_detect, reset, sel_b1, sel_b2, led_out);
    end

endmodule
