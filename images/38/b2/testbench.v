`timescale 1ns/1ps

module rnn_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] h_prev;
    reg reset;
    reg [4:0] x;
    wire [4:0] h_new;
    wire [4:0] y;

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
        .h_new(h_new),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Task: Resetting DUT...");
            reset = 1;
            x = 0;
            h_prev = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Inputs", test_num);
            reset_dut();

            x = 5'd0;
            h_prev = 5'd0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(5'd0, 5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input 'x' influence", test_num);
            reset_dut();

            x = 5'd10;
            h_prev = 5'd0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(5'd10, 5'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Hidden state influence", test_num);
            reset_dut();

            x = 5'd0;
            h_prev = 5'd15;

            @(posedge clk);
            #2;


            #1;



            check_outputs(5'd15, 5'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Combined Addition", test_num);
            reset_dut();

            x = 5'd7;
            h_prev = 5'd8;

            @(posedge clk);
            #2;


            #1;



            check_outputs(5'd15, 5'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max Value / Overflow check", test_num);
            reset_dut();

            x = 5'd20;
            h_prev = 5'd20;

            @(posedge clk);
            #2;


            #1;



            check_outputs(5'd8, 5'd8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Synchronous Reset override", test_num);
            reset_dut();

            x = 5'd10;
            h_prev = 5'd10;
            reset = 1;

            @(posedge clk);
            #2;


            #1;



            check_outputs(5'd0, 5'd0);
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
        input [4:0] expected_h_new;
        input [4:0] expected_y;
        begin
            if (expected_h_new === (expected_h_new ^ h_new ^ expected_h_new) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: h_new=%h, y=%h",
                         h_new, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h_new=%h, y=%h",
                         expected_h_new, expected_y);
                $display("  Got:      h_new=%h, y=%h",
                         h_new, y);
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
        $dumpvars(0,clk, h_prev, reset, x, h_new, y);
    end

endmodule
