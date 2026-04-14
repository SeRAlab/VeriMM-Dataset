`timescale 1ns/1ps

module wb_dma_inc30r_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [29:0] in;
    wire [29:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wb_dma_inc30r dut (
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
            $display("Resetting/Initializing DUT...");
            in = 30'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Increment from zero");
            test_num = test_num + 1;
            reset_dut();
            in = 30'h0000_0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(30'h0000_0001);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Simple increment middle range");
            test_num = test_num + 1;
            reset_dut();
            in = 30'h0F0F_0F0F;
            @(posedge clk);
            #2;
            #1;

            check_outputs(30'h0F0F_0F10);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Carry propagation to upper portion");
            test_num = test_num + 1;
            reset_dut();

            in = 30'h0000_7FFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(30'h0000_8000);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Overflow / Wrap-around");
            test_num = test_num + 1;
            reset_dut();
            in = 30'h3FFF_FFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(30'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Alternating bit pattern");
            test_num = test_num + 1;
            reset_dut();
            in = 30'h2AAA_AAAA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(30'h2AAA_AAAB);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Back-to-back operation");
            test_num = test_num + 1;
            reset_dut();

            in = 30'h0000_0005;
            @(posedge clk);
            #1;


            in = 30'h0000_000A;
            #1;
            #1;

            check_outputs(30'h0000_0006);

            @(posedge clk);
            #2;
            #1;

            check_outputs(30'h0000_000B);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wb_dma_inc30r Testbench");
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
        input [29:0] expected_out;
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
