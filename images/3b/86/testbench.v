`timescale 1ns/1ps

module rnn_inference_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg din;
    reg rst;
    wire dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_inference dut (
        .clk(clk),
        .din(din),
        .rst(rst),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            din = 0;
            @(posedge clk);
            #1;
            rst = 0;

        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            din = 1;
            @(posedge clk);
            #1;
            $display("Test Case 001: Single Input 1");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            din = 0;
            @(posedge clk);
            #1;
            $display("Test Case 002: Single Input 0");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            din = 1; @(posedge clk);
            din = 1; @(posedge clk);
            #1;
            $display("Test Case 003: Sequence 1-1");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            din = 1; @(posedge clk);
            din = 0; @(posedge clk);
            #1;
            $display("Test Case 004: Sequence 1-0");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            din = 1; @(posedge clk);
            din = 1; @(posedge clk);
            din = 1; @(posedge clk);
            #1;
            $display("Test Case 005: Sequence 1-1-1");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            din = 0; @(posedge clk);
            din = 1; @(posedge clk);
            din = 1; @(posedge clk);
            #1;
            $display("Test Case 006: Sequence 0-1-1");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            din = 1; @(posedge clk);
            din = 0; @(posedge clk);
            din = 1; @(posedge clk);
            din = 0; @(posedge clk);
            #1;
            $display("Test Case 007: Sequence 1-0-1-0");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            din = 1; @(posedge clk);
            din = 1; @(posedge clk);
            din = 1; @(posedge clk);
            din = 1; @(posedge clk);
            #1;
            $display("Test Case 008: Sequence 1-1-1-1");
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rnn_inference Testbench");
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
        input expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%b",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%b",
                         expected_dout);
                $display("  Got:      dout=%b",
                         dout);
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
        $dumpvars(0,clk, din, rst, dout);
    end

endmodule
