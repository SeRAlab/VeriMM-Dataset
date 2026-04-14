`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg graph_on;
    reg [1:0] state_reg;
    reg [3:0] text_on;
    wire [2:0] rgb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .graph_on(graph_on),
        .state_reg(state_reg),
        .text_on(text_on),
        .rgb(rgb)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            state_reg = 2'b00;
            text_on = 4'b0000;
            graph_on = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            state_reg = 2'b00;
            text_on = 4'b0001;
            graph_on = 1'b0;
            @(posedge clk);
            #1;
            $display("Test Case 001: Text On (State 0) -> Expected White");
            #1;

            check_outputs(WHITE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            state_reg = 2'b01;
            text_on = 4'b0000;
            graph_on = 1'b1;
            @(posedge clk);
            #1;
            $display("Test Case 002: Graph On (Text Off) -> Expected Blue");
            #1;

            check_outputs(BLUE);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            state_reg = 2'b10;
            text_on = 4'b0000;
            graph_on = 1'b0;
            @(posedge clk);
            #1;
            $display("Test Case 003: Both Off -> Expected Yellow");
            #1;

            check_outputs(YELLOW);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            state_reg = 2'b11;
            text_on = 4'b1000;
            graph_on = 1'b1;
            @(posedge clk);
            #1;
            $display("Test Case 004: Text Priority over Graph -> Expected White");
            #1;

            check_outputs(WHITE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            state_reg = 2'b01;
            text_on = 4'b0010;
            graph_on = 1'b0;
            @(posedge clk);
            #1;
            $display("Test Case 005: Text On (State 1) -> Expected White");
            #1;

            check_outputs(WHITE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            state_reg = 2'b00;
            text_on = 4'b1110;
            graph_on = 1'b1;
            @(posedge clk);
            #1;
            $display("Test Case 006: Wrong State Text Bit -> Expected Blue (Graph)");
            #1;

            check_outputs(BLUE);
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
        input [2:0] expected_rgb;
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
        $dumpvars(0,clk, graph_on, state_reg, text_on, rgb);
    end

endmodule
