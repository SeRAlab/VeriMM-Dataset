`timescale 1ns/1ps

module RLE_Encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg valid_in;
    wire [3:0] count_out;
    wire [7:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RLE_Encoder dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid_in(valid_in),
        .count_out(count_out),
        .data_out(data_out),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 8'h0;
            valid_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: 5 consecutive identical values");
            reset_dut();

            @(posedge clk);
            data_in = 8'hAA;
            valid_in = 1;
            repeat (5) @(posedge clk);

            valid_in = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(4'd5, 8'hAA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Single occurrence of a value");
            reset_dut();

            @(posedge clk);
            data_in = 8'h55;
            valid_in = 1;
            @(posedge clk);

            valid_in = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(4'd1, 8'h55, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Multiple runs (Final check)");
            reset_dut();

            @(posedge clk);
            valid_in = 1;

            data_in = 8'h11;
            repeat (3) @(posedge clk);

            data_in = 8'h22;
            repeat (2) @(posedge clk);

            data_in = 8'h33;
            repeat (4) @(posedge clk);

            valid_in = 0;
            wait(done);
            @(posedge clk);

            #1;


            check_outputs(4'd4, 8'h33, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Large run (10 items)");
            reset_dut();

            @(posedge clk);
            data_in = 8'hFF;
            valid_in = 1;
            repeat (10) @(posedge clk);

            valid_in = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(4'd10, 8'hFF, 1'b1);
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
        input [3:0] expected_count_out;
        input [7:0] expected_data_out;
        input expected_done;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h, data_out=%h, done=%b",
                         count_out, data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h, data_out=%h, done=%b",
                         expected_count_out, expected_data_out, expected_done);
                $display("  Got:      count_out=%h, data_out=%h, done=%b",
                         count_out, data_out, done);
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
        $dumpvars(0,clk, data_in, rst, valid_in, count_out, data_out, done);
    end

endmodule
