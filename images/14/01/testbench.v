`timescale 1ns/1ps

module lfsr_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lfsr_32bit dut (
        .clk(clk),
        .rst(rst),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Reset State...", test_num);
            reset_dut();
            #1;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying state after 1 cycle...", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying state after 12 cycles...", test_num);
            reset_dut();
            repeat(12) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00001000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying state after 13 cycles (First Feedback)...", test_num);
            reset_dut();
            repeat(13) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00002001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying state after 16 cycles...", test_num);
            reset_dut();
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0001000F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying state after 22 cycles...", test_num);
            reset_dut();
            repeat(22) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h004003FE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lfsr_32bit Testbench");
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
        input [31:0] expected_out;
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
        $dumpvars(0,clk, rst, out);
    end

endmodule
