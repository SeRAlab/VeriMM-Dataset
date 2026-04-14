`timescale 1ns/1ps

module jt51_sum_op_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en_ch;
    reg [13:0] op_out;
    reg zero;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    jt51_sum_op dut (
        .clk(clk),
        .en_ch(en_ch),
        .op_out(op_out),
        .zero(zero),
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
            zero = 1;
            en_ch = 1;
            op_out = 14'd0;
            @(posedge clk);
            zero = 0;
            en_ch = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(posedge clk);
            zero = 1;
            en_ch = 1;
            op_out = 14'sd1234;
            @(posedge clk);
            zero = 0;
            en_ch = 0;
            $display("Testcase 001: Initialization");
            #1;

            check_outputs(16'sd1234);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            zero = 1; en_ch = 1; op_out = 14'sd1000;
            @(posedge clk);
            zero = 0; en_ch = 1; op_out = 14'sd2000;
            @(posedge clk);
            zero = 0; en_ch = 1; op_out = 14'sd-500;
            @(posedge clk);
            en_ch = 0;
            $display("Testcase 002: Simple Accumulation");
            #1;

            check_outputs(16'sd2500);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge clk);
            zero = 1; en_ch = 1; op_out = 14'sd5000;
            @(posedge clk);
            zero = 0; en_ch = 0; op_out = 14'sd1000;
            @(posedge clk);
            op_out = 14'sd2000;
            @(posedge clk);
            $display("Testcase 003: Enable Gating (Hold Value)");
            #1;

            check_outputs(16'sd5000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge clk);
            zero = 1; en_ch = 1; op_out = 14'sd8191;
            @(posedge clk);
            zero = 0; op_out = 14'sd8191;
            @(posedge clk);
            op_out = 14'sd8191;
            @(posedge clk);
            op_out = 14'sd8191;
            @(posedge clk);
            op_out = 14'sd8191;
            @(posedge clk);
            en_ch = 0;
            $display("Testcase 004: Positive Saturation");
            #1;

            check_outputs(16'sh7FFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge clk);
            zero = 1; en_ch = 1; op_out = -14'sd8192;
            @(posedge clk);
            zero = 0; op_out = -14'sd8192;
            @(posedge clk);
            op_out = -14'sd8192;
            @(posedge clk);
            op_out = -14'sd8192;
            @(posedge clk);
            op_out = -14'sd8192;
            @(posedge clk);
            en_ch = 0;
            $display("Testcase 005: Negative Saturation");
            #1;

            check_outputs(16'sh8000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("jt51_sum_op Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [15:0] expected_out;
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
        $dumpvars(0,clk, en_ch, op_out, zero, out);
    end

endmodule
