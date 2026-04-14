`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [4:0] x;
    wire [4:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rnn_cell dut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x = 5'b0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning Testcase %0d: Zero Input", test_num);
            reset_dut();
            x = 5'b00000;
            @(posedge clk);
            #2;


            #1;



            check_outputs(5'h04);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning Testcase %0d: Mid-range Input (01010)", test_num);
            reset_dut();
            x = 5'b01010;
            @(posedge clk);
            #2;

            #1;


            check_outputs(5'h0A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning Testcase %0d: Maximum Input (11111)", test_num);
            reset_dut();
            x = 5'b11111;
            @(posedge clk);
            #2;

            #1;


            check_outputs(5'h1F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning Testcase %0d: Sequential Input Sequence", test_num);
            reset_dut();


            x = 5'b00010;
            @(posedge clk);
            #2;


            x = 5'b00100;
            @(posedge clk);
            #2;


            #1;



            check_outputs(5'h12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nRunning Testcase %0d: Reset during operation", test_num);
            reset_dut();

            x = 5'b11111;
            @(posedge clk);
            #2;


            rst = 1;
            @(posedge clk);
            #2;
            rst = 0;
            x = 5'b00000;
            @(posedge clk);
            #2;


            #1;



            check_outputs(5'h04);
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
        input [4:0] expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
        $dumpvars(0,clk, rst, x, y);
    end

endmodule
