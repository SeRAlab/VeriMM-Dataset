`timescale 1ns/1ps

module RLE_Encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg rst;
    wire [1:0] count_out;
    wire data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RLE_Encoder dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .count_out(count_out),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Single '1' bit", test_num);
            reset_dut();
            data_in = 1; @(posedge clk);
            data_in = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(2'd1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: Single '0' bit", test_num);
            reset_dut();
            data_in = 0; @(posedge clk);
            data_in = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(2'd1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Two '1's", test_num);
            reset_dut();
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(2'd2, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Two '0's", test_num);
            reset_dut();
            data_in = 0; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(2'd2, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %03d: Three '1's (Max Count)", test_num);
            reset_dut();
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(2'd3, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase %03d: Three '0's (Max Count)", test_num);
            reset_dut();
            data_in = 0; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(2'd3, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Running Testcase %03d: Reset mid-run", test_num);
            reset_dut();
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            rst = 1;     @(posedge clk);
            #1 rst = 0;
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            #1 #1;
 check_outputs(2'd1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RLE_Encoder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [1:0] expected_count_out;
        input expected_data_out;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h, data_out=%b",
                         count_out, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h, data_out=%b",
                         expected_count_out, expected_data_out);
                $display("  Got:      count_out=%h, data_out=%b",
                         count_out, data_out);
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
        $dumpvars(0,clk, data_in, rst, count_out, data_out);
    end

endmodule
