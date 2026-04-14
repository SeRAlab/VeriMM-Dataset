`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] b;
    reg clk;
    reg [4:0] h_prev;
    reg [24:0] w_h;
    reg [24:0] w_in;
    reg [4:0] x;
    wire [4:0] h_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .b(b),
        .clk(clk),
        .h_prev(h_prev),
        .w_h(w_h),
        .w_in(w_in),
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
            b = 5'b00000;
            h_prev = 5'b00000;
            w_h = 25'h0;
            w_in = 25'h0;
            x = 5'b00000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            x = 5'b00000;
            h_prev = 5'b00000;
            w_in = 25'h0;
            w_h = 25'h0;
            b = 5'b00000;
            @(posedge clk);
            #2;
            $display("Testcase 001: All Zeros");
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            x = 5'b10101;
            h_prev = 5'b00000;
            w_in = 25'h1041041;
            w_h = 25'h0;
            b = 5'b00000;
            @(posedge clk);
            #2;
            $display("Testcase 002: Identity Input Weights (x=10101)");
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            x = 5'b00000;
            h_prev = 5'b01010;
            w_in = 25'h0;
            w_h = 25'h1041041;
            b = 5'b00000;
            @(posedge clk);
            #2;
            $display("Testcase 003: Identity Hidden Weights (h_prev=01010)");
            #1;

            check_outputs(5'b01010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            x = 5'b00000;
            h_prev = 5'b00000;
            w_in = 25'h0;
            w_h = 25'h0;
            b = 5'b11111;
            @(posedge clk);
            #2;
            $display("Testcase 004: Bias Only (b=11111)");
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            x = 5'b00001;
            h_prev = 5'b00001;
            w_in = 25'h1041041;
            w_h = 25'h1041041;
            b = 5'b00000;
            @(posedge clk);
            #2;
            $display("Testcase 005: Overlapping x and h_prev");
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            x = 5'b00001;
            h_prev = 5'b00000;
            w_in = 25'h1000000;
            w_h = 25'h0;
            b = 5'b00000;

            w_in = (1 << 20);
            @(posedge clk);
            #2;
            $display("Testcase 006: Weight mapping (x[0] -> h_out[4])");
            #1;

            check_outputs(5'b10000);
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
        input [4:0] expected_h_out;
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
        $dumpvars(0,b, clk, h_prev, w_h, w_in, x, h_out);
    end

endmodule
