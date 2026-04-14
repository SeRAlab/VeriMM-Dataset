`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg reset;
    wire [3:0] count;
    wire data_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .count(count),
        .data_out(data_out),
        .valid(valid)
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
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Run of three 0s", test_num);
            reset_dut();

            data_in = 0; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 0; @(posedge clk);

            data_in = 1; @(negedge clk);
            #1;

            check_outputs(4'd3, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Run of five 1s", test_num);
            reset_dut();

            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);
            data_in = 1; @(posedge clk);

            data_in = 0; @(negedge clk);
            #1;

            check_outputs(4'd5, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %03d: Max count (15) of 1s", test_num);
            reset_dut();

            data_in = 1;
            for (i = 0; i < 15; i = i + 1) begin
                @(posedge clk);
            end

            @(negedge clk);
            #1;

            check_outputs(4'd15, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %03d: Max count (15) of 0s", test_num);
            reset_dut();

            data_in = 0;
            for (i = 0; i < 15; i = i + 1) begin
                @(posedge clk);
            end
            @(negedge clk);
            #1;

            check_outputs(4'd15, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Alternating bits (single run)", test_num);
            reset_dut();
            data_in = 1; @(posedge clk);
            data_in = 0; @(negedge clk);
            #1;

            check_outputs(4'd1, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %03d: 16 consecutive 1s (check overflow and restart)", test_num);
            reset_dut();

            data_in = 1;
            for (i = 0; i < 15; i = i + 1) @(posedge clk);

            @(negedge clk);

            @(posedge clk);
            data_in = 0; @(negedge clk);
            #1;

            check_outputs(4'd1, 1'b1, 1'b1);
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
        input [3:0] expected_count;
        input expected_data_out;
        input expected_valid;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: count=%h, data_out=%b, valid=%b",
                         count, data_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, data_out=%b, valid=%b",
                         expected_count, expected_data_out, expected_valid);
                $display("  Got:      count=%h, data_out=%b, valid=%b",
                         count, data_out, valid);
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
        $dumpvars(0,clk, data_in, reset, count, data_out, valid);
    end

endmodule
