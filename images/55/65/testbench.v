`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in;
    reg reset;
    wire [1:0] pos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .pos(pos)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 4'b0000;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            in = 4'b1000;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Test %0d: Input 1000 (Bit 3)", test_num);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            in = 4'b0100;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Test %0d: Input 0100 (Bit 2)", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            in = 4'b0010;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Test %0d: Input 0010 (Bit 1)", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            in = 4'b0001;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Test %0d: Input 0001 (Bit 0)", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            in = 4'b0000;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Test %0d: Input 0000 (None)", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            in = 4'b1100;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Test %0d: Input 1100 (Bit 3 Priority)", test_num);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            in = 4'b0111;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Test %0d: Input 0111 (Bit 2 Priority)", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            in = 4'b1111;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Test %0d: Input 1111 (Bit 3 Priority)", test_num);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            in = 4'b0011;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Test %0d: Input 0011 (Bit 1 Priority)", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            in = 4'b1111;
            reset = 1;
            @(posedge clk);
            #2;
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Reset with active inputs", test_num);
            #1;

            check_outputs(2'b00);
            reset = 0;
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [1:0] expected_pos;
        begin
            if (expected_pos === (expected_pos ^ pos ^ expected_pos)) begin
                $display("PASS");
                $display("  Outputs: pos=%h",
                         pos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pos=%h",
                         expected_pos);
                $display("  Got:      pos=%h",
                         pos);
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
        $dumpvars(0,clk, in, reset, pos);
    end

endmodule
