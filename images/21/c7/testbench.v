`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [3:0] x;
    wire [3:0] h;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .h(h)
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
            @(posedge clk);
            #1 rst = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single input processing", test_num);
            reset_dut();

            x = 4'd5;
            @(posedge clk);

            #1;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple input sequence", test_num);
            reset_dut();

            x = 4'd2; @(posedge clk);
            x = 4'd3; @(posedge clk);
            x = 4'd1; @(posedge clk);

            #1;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero input persistence", test_num);
            reset_dut();

            x = 4'd7; @(posedge clk);
            x = 4'd0; @(posedge clk);
            x = 4'd0; @(posedge clk);

            #1;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 4-bit wrap-around check", test_num);
            reset_dut();

            x = 4'd8; @(posedge clk);
            x = 4'd9; @(posedge clk);

            #1;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum value sequence", test_num);
            reset_dut();

            x = 4'hf; @(posedge clk);
            x = 4'hf; @(posedge clk);
            x = 4'h1; @(posedge clk);

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
        $display("rnn_cell Testbench");
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
        input [3:0] expected_h;
        begin
            if (expected_h === (expected_h ^ h ^ expected_h)) begin
                $display("PASS");
                $display("  Outputs: h=%h",
                         h);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h=%h",
                         expected_h);
                $display("  Got:      h=%h",
                         h);
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
        $dumpvars(0,clk, rst, x, h);
    end

endmodule
