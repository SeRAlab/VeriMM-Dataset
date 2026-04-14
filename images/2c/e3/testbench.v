`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] h_prev;
    reg rst;
    reg [3:0] x;
    wire [3:0] h_new;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .clk(clk),
        .h_prev(h_prev),
        .rst(rst),
        .x(x),
        .h_new(h_new)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x = 4'b0;
            h_prev = 4'b0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Zero Inputs", test_num);
            reset_dut();
            x = 4'd0;
            h_prev = 4'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Maximum Input x", test_num);
            reset_dut();
            x = 4'hF;
            h_prev = 4'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Maximum Hidden State h_prev", test_num);
            reset_dut();
            x = 4'd0;
            h_prev = 4'hF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Sub-threshold Inputs", test_num);
            reset_dut();
            x = 4'd1;
            h_prev = 4'd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Mid-range Boundary Test", test_num);
            reset_dut();
            x = 4'd4;
            h_prev = 4'd4;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Alternating Bit Patterns", test_num);
            reset_dut();
            x = 4'hA;
            h_prev = 4'h5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hF);
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
        input [3:0] expected_h_new;
        begin
            if (expected_h_new === (expected_h_new ^ h_new ^ expected_h_new)) begin
                $display("PASS");
                $display("  Outputs: h_new=%h",
                         h_new);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h_new=%h",
                         expected_h_new);
                $display("  Got:      h_new=%h",
                         h_new);
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
        $dumpvars(0,clk, h_prev, rst, x, h_new);
    end

endmodule
