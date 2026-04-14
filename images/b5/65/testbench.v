`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 4'b0000;

            repeat (4) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift in sequence 1, 1, 1, 1", test_num);
            reset_dut();

            @(posedge clk); data_in = 4'b0001;
            @(posedge clk); data_in = 4'b0001;
            @(posedge clk); data_in = 4'b0001;
            @(posedge clk); data_in = 4'b0001;

            #2;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift in sequence 1, 0, 1, 0", test_num);
            reset_dut();

            @(posedge clk); data_in = 4'b0001;
            @(posedge clk); data_in = 4'b0000;
            @(posedge clk); data_in = 4'b0001;
            @(posedge clk); data_in = 4'b0000;

            #2;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift in sequence 1, 0, 0, 0", test_num);
            reset_dut();

            @(posedge clk); data_in = 4'b0001;
            @(posedge clk); data_in = 4'b0000;
            @(posedge clk); data_in = 4'b0000;
            @(posedge clk); data_in = 4'b0000;

            #2;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift in sequence 0, 1, 1, 0", test_num);
            reset_dut();

            @(posedge clk); data_in = 4'b0000;
            @(posedge clk); data_in = 4'b0001;
            @(posedge clk); data_in = 4'b0001;
            @(posedge clk); data_in = 4'b0000;

            #2;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Perform 5 shifts with sequence 1, 1, 0, 0, 1", test_num);
            reset_dut();

            @(posedge clk); data_in = 4'b0001;
            @(posedge clk); data_in = 4'b0001;
            @(posedge clk); data_in = 4'b0000;
            @(posedge clk); data_in = 4'b0000;
            @(posedge clk); data_in = 4'b0001;

            #2;
            #1;

            check_outputs(4'b1001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [3:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, data_out);
    end

endmodule
