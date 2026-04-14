`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] h_prev;
    reg reset;
    reg [3:0] x;
    wire [3:0] h_out;
    wire [3:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .clk(clk),
        .h_prev(h_prev),
        .reset(reset),
        .x(x),
        .h_out(h_out),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            x = 0;
            h_prev = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Inputs", test_num);
            reset_dut();

            x = 4'h0;
            h_prev = 4'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Addition", test_num);
            reset_dut();

            x = 4'h2;
            h_prev = 4'h3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h5, 4'h5);
        end
        endtask

    task testcase003;

        reg [3:0] step1_h;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Time Steps", test_num);
            reset_dut();


            x = 4'h1;
            h_prev = 4'h0;
            @(posedge clk);
            #1;
            step1_h = h_out;


            x = 4'h2;
            h_prev = step1_h;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h3, 4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Values (Overflow/Wrap)", test_num);
            reset_dut();

            x = 4'hA;
            h_prev = 4'h7;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h1, 4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: ReLU Negative Clamping", test_num);
            reset_dut();

            x = 4'hB;
            h_prev = 4'h2;
            @(posedge clk);
            #1;



            #1;




            check_outputs(4'h0, 4'h0);
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
        input [3:0] expected_h_out;
        input [3:0] expected_y;
        begin
            if (expected_h_out === (expected_h_out ^ h_out ^ expected_h_out) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: h_out=%h, y=%h",
                         h_out, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h_out=%h, y=%h",
                         expected_h_out, expected_y);
                $display("  Got:      h_out=%h, y=%h",
                         h_out, y);
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
        $dumpvars(0,clk, h_prev, reset, x, h_out, y);
    end

endmodule
