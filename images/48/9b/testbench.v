`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] in;
    reg reset_n;
    wire [63:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset_n(reset_n),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset_n = 0;
            in = 64'h0;
            @(posedge clk);
            reset_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Initial Reset Check", test_num);
            reset_dut();
            @(posedge clk);
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Bit Falling Edge (Bit 0)", test_num);
            reset_dut();
            @(posedge clk);
            in = 64'h0000_0000_0000_0001;
            @(posedge clk);
            in = 64'h0000_0000_0000_0000;
            @(posedge clk);
            #1;

            check_outputs(64'h0000_0000_0000_0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple Bits Falling Edge", test_num);
            reset_dut();
            @(posedge clk);
            in = 64'hAAAA_AAAA_AAAA_AAAA;
            @(posedge clk);
            in = 64'h5555_5555_5555_5555;
            @(posedge clk);
            #1;

            check_outputs(64'hAAAA_AAAA_AAAA_AAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sticky Property Check", test_num);
            reset_dut();
            @(posedge clk);
            in = 64'h0000_0000_FFFF_0000;
            @(posedge clk);
            in = 64'h0000_0000_0000_0000;
            @(posedge clk);
            in = 64'hFFFF_FFFF_FFFF_FFFF;
            @(posedge clk);
            in = 64'hFFFF_FFFF_FFFF_FFFF;
            @(posedge clk);
            #1;

            check_outputs(64'h0000_0000_FFFF_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Rising Edge Should Not Trigger", test_num);
            reset_dut();
            @(posedge clk);
            in = 64'h0;
            @(posedge clk);
            in = 64'hFFFF_FFFF_FFFF_FFFF;
            @(posedge clk);
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Cumulative Capture Over Time", test_num);
            reset_dut();

            @(posedge clk); in = 64'h1;
            @(posedge clk); in = 64'h0;

            @(posedge clk); in = 64'h2;
            @(posedge clk); in = 64'h0;

            @(posedge clk); in = 64'h8000_0000_0000_0000;
            @(posedge clk); in = 64'h0;
            @(posedge clk);
            #1;

            check_outputs(64'h8000_0000_0000_0003);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mid-operation Reset", test_num);
            reset_dut();
            @(posedge clk);
            in = 64'hF;
            @(posedge clk);
            in = 64'h0;
            @(posedge clk);

            if (out == 64'hF) begin
                reset_n = 0;
                @(posedge clk);
                reset_n = 1;
                @(posedge clk);
                #1;

                check_outputs(64'h0);
            end else begin
                $display("FAIL: Initial capture failed");
                fail_count = fail_count + 1;
            end
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
        input [63:0] expected_out;
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
        $dumpvars(0,clk, in, reset_n, out);
    end

endmodule
