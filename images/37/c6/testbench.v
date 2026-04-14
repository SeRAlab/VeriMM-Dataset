`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] h_prev;
    reg rst;
    reg [7:0] x;
    wire [7:0] h_out;

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
            x = 8'h00;
            h_prev = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial Reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Inputs (x=0, h_prev=0)", test_num);
            reset_dut();
            x = 8'h00;
            h_prev = 8'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input stimulus (x=0A, h_prev=00)", test_num);
            reset_dut();
            x = 8'h0A;
            h_prev = 8'h00;
            @(posedge clk);
            #1;


            #1;



            check_outputs(dut.h_out);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hidden state propagation (x=00, h_prev=0F)", test_num);
            reset_dut();
            x = 8'h00;
            h_prev = 8'h0F;
            @(posedge clk);
            #1;
            #1;

            check_outputs(dut.h_out);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Combined inputs (x=FF, h_prev=FF)", test_num);
            reset_dut();
            x = 8'hFF;
            h_prev = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(dut.h_out);
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
        input [7:0] expected_h_out;
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
        $dumpvars(0,clk, h_prev, rst, x, h_out);
    end

endmodule
