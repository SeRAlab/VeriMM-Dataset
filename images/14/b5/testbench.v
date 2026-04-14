`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg reset;
    wire [7:0] char_out;
    wire [7:0] count_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .char_out(char_out),
        .count_out(count_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Run of five 0s");
            reset_dut();
            @(negedge clk);
            data_in = 0;
            repeat (5) @(negedge clk);
            data_in = 1;


            while (!valid_out) @(posedge clk);
            #1;

            check_outputs(8'd0, 8'd5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Run of ten 1s");
            reset_dut();
            @(negedge clk);
            data_in = 1;
            repeat (10) @(negedge clk);
            data_in = 0;

            while (!valid_out) @(posedge clk);
            #1;

            check_outputs(8'd1, 8'd10, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Single bit run (0)");
            reset_dut();
            @(negedge clk);
            data_in = 0;
            @(negedge clk);
            data_in = 1;

            while (!valid_out) @(posedge clk);
            #1;

            check_outputs(8'd0, 8'd1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Single bit run (1)");
            reset_dut();
            @(negedge clk);
            data_in = 1;
            @(negedge clk);
            data_in = 0;

            while (!valid_out) @(posedge clk);
            #1;

            check_outputs(8'd1, 8'd1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Max length run (255 zeros)");
            reset_dut();
            @(negedge clk);
            data_in = 0;
            repeat (255) @(negedge clk);




            if (!valid_out) begin
                data_in = 1;
                while (!valid_out) @(posedge clk);
            end

            #1;


            check_outputs(8'd0, 8'd255, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Rapid alternating bits");
            reset_dut();
            @(negedge clk);
            data_in = 0; @(negedge clk);
            data_in = 1; @(negedge clk);
            data_in = 0;


            while (!valid_out) @(posedge clk);

            #1;


            check_outputs(8'd1, 8'd1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rle_encoder Testbench");
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
        input [7:0] expected_char_out;
        input [7:0] expected_count_out;
        input expected_valid_out;
        begin
            if (expected_char_out === (expected_char_out ^ char_out ^ expected_char_out) &&
                expected_count_out === (expected_count_out ^ count_out ^ expected_count_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: char_out=%h, count_out=%h, valid_out=%b",
                         char_out, count_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: char_out=%h, count_out=%h, valid_out=%b",
                         expected_char_out, expected_count_out, expected_valid_out);
                $display("  Got:      char_out=%h, count_out=%h, valid_out=%b",
                         char_out, count_out, valid_out);
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
        $dumpvars(0,clk, data_in, reset, char_out, count_out, valid_out);
    end

endmodule
