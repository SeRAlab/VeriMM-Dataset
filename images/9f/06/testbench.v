`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            in = 4'b0000;
            @(posedge clk);
            #2;
            $write("Testcase 001 (In: 0000): ");
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            in = 4'b0001;
            @(posedge clk);
            #2;
            $write("Testcase 002 (In: 0001): ");
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            in = 4'b0011;
            @(posedge clk);
            #2;
            $write("Testcase 003 (In: 0011): ");
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            in = 4'b0100;
            @(posedge clk);
            #2;
            $write("Testcase 004 (In: 0100): ");
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            in = 4'b0111;
            @(posedge clk);
            #2;
            $write("Testcase 005 (In: 0111): ");
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            in = 4'b1000;
            @(posedge clk);
            #2;
            $write("Testcase 006 (In: 1000): ");
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            in = 4'b1010;
            @(posedge clk);
            #2;
            $write("Testcase 007 (In: 1010): ");
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            in = 4'b1100;
            @(posedge clk);
            #2;
            $write("Testcase 008 (In: 1100): ");
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            in = 4'b1111;
            @(posedge clk);
            #2;
            $write("Testcase 009 (In: 1111): ");
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            in = 4'b1001;
            @(posedge clk);
            #2;
            $write("Testcase 010 (In: 1001): ");
            #1;

            check_outputs(4'b1101);
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
        input [3:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in, out);
    end

endmodule
