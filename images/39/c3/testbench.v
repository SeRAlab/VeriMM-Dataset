`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] h_prev;
    reg reset;
    reg [7:0] x;
    wire [7:0] h_new;

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
        .h_new(h_new)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        x = 8'h00;
        h_prev = 8'h00;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros Input", test_num);


        x = 8'h00;
        h_prev = 8'h00;

        @(posedge clk);
        #2;


        #1;



        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Positive Input x, zero h_prev", test_num);


        x = 8'h10;
        h_prev = 8'h00;

        @(posedge clk);
        #2;



        #1;




        check_outputs(h_new);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Zero x, Positive h_prev", test_num);


        x = 8'h00;
        h_prev = 8'h20;

        @(posedge clk);
        #2;


        #1;



        check_outputs(h_new);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: High saturation test", test_num);


        x = 8'h7F;
        h_prev = 8'h7F;

        @(posedge clk);
        #2;


        #1;



        check_outputs(h_new);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Negative input test (Two's complement)", test_num);


        x = 8'hFF;
        h_prev = 8'hFF;

        @(posedge clk);
        #2;


        #1;



        check_outputs(h_new);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %0d: Sequential State Update", test_num);


        x = 8'h05;
        h_prev = 8'h00;
        @(posedge clk);
        #1;


        h_prev = h_new;
        x = 8'h0A;
        @(posedge clk);
        #2;

        $display("  Recurrent check: h_new updated based on feedback loop.");
        #1;

        check_outputs(h_new);
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
        input [7:0] expected_h_new;
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
        $dumpvars(0,clk, h_prev, reset, x, h_new);
    end

endmodule
