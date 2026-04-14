`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] h_in;
    reg rst;
    reg [3:0] x;
    wire [3:0] h_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .clk(clk),
        .h_in(h_in),
        .rst(rst),
        .x(x),
        .h_out(h_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x = 0;
            h_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Positive addition (2 + 2 = 4)", test_num);
            x = 4'sd2;
            h_in = 4'sd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'sd4);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Positive + Negative = Positive (5 + -2 = 3)", test_num);
            x = 4'sd5;
            h_in = -4'sd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'sd3);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Positive + Negative = Negative (2 + -5 = -3 -> ReLU 0)", test_num);
            x = 4'sd2;
            h_in = -4'sd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'sd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Negative + Negative = Negative (-1 + -3 = -4 -> ReLU 0)", test_num);
            x = -4'sd1;
            h_in = -4'sd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'sd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Zero inputs (0 + 0 = 0)", test_num);
            x = 4'sd0;
            h_in = 4'sd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'sd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Max positive boundary (7 + 0 = 7)", test_num);
            x = 4'sd7;
            h_in = 4'sd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'sd7);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Max negative boundary (-8 + 0 = -8 -> ReLU 0)", test_num);
            x = -4'sd8;
            h_in = 4'sd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'sd0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Positive overflow wrapping (7 + 1 = -8 -> ReLU 0)", test_num);
            x = 4'sd7;
            h_in = 4'sd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'sd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rnn_cell Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [3:0] expected_h_out;
        begin
            if (expected_h_out === (expected_h_out ^ h_out ^ expected_h_out)) begin
                $display("PASS");
                $display("  Outputs: h_out=%h",
                         h_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h_out=%h",
                         expected_h_out);
                $display("  Got:      h_out=%h",
                         h_out);
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
        $dumpvars(0,clk, h_in, rst, x, h_out);
    end

endmodule
