`timescale 1ns/1ps

module rnn_inference_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [3:0] x_t;
    wire [3:0] h_t;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_inference dut (
        .clk(clk),
        .reset(reset),
        .x_t(x_t),
        .h_t(h_t)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            x_t = 4'd0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Single Addition", test_num);
            reset_dut();

            x_t = 4'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Accumulation over 3 cycles", test_num);
            reset_dut();

            x_t = 4'd2;
            @(posedge clk);
            x_t = 4'd3;
            @(posedge clk);
            x_t = 4'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd9);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow Wrap-around", test_num);
            reset_dut();

            x_t = 4'd10;
            @(posedge clk);
            x_t = 4'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Value to Zero wrap", test_num);
            reset_dut();

            x_t = 4'd15;
            @(posedge clk);
            x_t = 4'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Input Sequence", test_num);
            reset_dut();

            x_t = 4'd0;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Longer sequence 1-5", test_num);
            reset_dut();

            x_t = 4'd1; @(posedge clk);
            x_t = 4'd2; @(posedge clk);
            x_t = 4'd3; @(posedge clk);
            x_t = 4'd4; @(posedge clk);
            x_t = 4'd5; @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15);
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
        input [3:0] expected_h_t;
        begin
            if (expected_h_t === (expected_h_t ^ h_t ^ expected_h_t)) begin
                $display("PASS");
                $display("  Outputs: h_t=%h",
                         h_t);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h_t=%h",
                         expected_h_t);
                $display("  Got:      h_t=%h",
                         h_t);
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
        $dumpvars(0,clk, reset, x_t, h_t);
    end

endmodule
