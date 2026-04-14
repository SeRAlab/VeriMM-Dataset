`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in;
    wire [2:0] pos;
    wire [7:0] rising_edge;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .pos(pos),
        .rising_edge(rising_edge)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 8'b00000001;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Bit 0 rising edge", test_num);
            #1;

            check_outputs(3'd0, 8'b00000001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 8'b10000000;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Bit 7 rising edge", test_num);
            #1;

            check_outputs(3'd7, 8'b10000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 8'b10101010;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Multiple bits high (Priority Encoder check)", test_num);

            #1;


            check_outputs(3'd7, 8'b10101010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 8'b00001111;
            @(posedge clk);
            #1;
            in = 8'b00001111;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Signal remains high (Edge should clear)", test_num);

            #1;


            check_outputs(3'd3, 8'b00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 8'b11111111;
            @(posedge clk);
            #1;
            in = 8'b00000000;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Falling edges", test_num);

            #1;


            check_outputs(3'd0, 8'b00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 8'b00000100;
            @(posedge clk);
            #1;
            in = 8'b01000100;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Sequential bit activation", test_num);

            #1;


            check_outputs(3'd6, 8'b01000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 8'b11000000;
            @(posedge clk);
            #1;
            in = 8'b01000000;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Priority change (Bit 7 falls)", test_num);

            #1;


            check_outputs(3'd6, 8'b00000000);
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
        input [2:0] expected_pos;
        input [7:0] expected_rising_edge;
        begin
            if (expected_pos === (expected_pos ^ pos ^ expected_pos) &&
                expected_rising_edge === (expected_rising_edge ^ rising_edge ^ expected_rising_edge)) begin
                $display("PASS");
                $display("  Outputs: pos=%h, rising_edge=%h",
                         pos, rising_edge);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pos=%h, rising_edge=%h",
                         expected_pos, expected_rising_edge);
                $display("  Got:      pos=%h, rising_edge=%h",
                         pos, rising_edge);
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
        $dumpvars(0,clk, in, pos, rising_edge);
    end

endmodule
