`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg rst;
    wire data_out;
    wire [3:0] run_length;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .data_out(data_out),
        .run_length(run_length),
        .valid(valid)
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
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: 5 Zeros followed by bit change", test_num);
            reset_dut();
            repeat(5) begin
                data_in = 0;
                @(posedge clk);
            end
            data_in = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(0, 4'd5, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: 12 Ones followed by bit change", test_num);
            reset_dut();
            repeat(12) begin
                data_in = 1;
                @(posedge clk);
            end
            data_in = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1, 4'd12, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Run of exactly 15 bits (Overflow)", test_num);
            reset_dut();
            repeat(15) begin
                data_in = 0;
                @(posedge clk);
            end

            #1 #1;
 check_outputs(0, 4'd15, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Run of 16 bits (Check remainder)", test_num);
            reset_dut();
            repeat(15) begin
                data_in = 1;
                @(posedge clk);
            end

            data_in = 1;
            @(posedge clk);

            data_in = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1, 4'd1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Alternating bits", test_num);
            reset_dut();
            data_in = 1; @(posedge clk);
            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);
            #1 #1;
 check_outputs(0, 4'd1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Minimum bit change", test_num);
            reset_dut();
            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);
            #1 #1;
 check_outputs(0, 4'd1, 1);
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
        input expected_data_out;
        input [3:0] expected_run_length;
        input expected_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_run_length === (expected_run_length ^ run_length ^ expected_run_length) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b, run_length=%h, valid=%b",
                         data_out, run_length, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b, run_length=%h, valid=%b",
                         expected_data_out, expected_run_length, expected_valid);
                $display("  Got:      data_out=%b, run_length=%h, valid=%b",
                         data_out, run_length, valid);
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
        $dumpvars(0,clk, data_in, rst, data_out, run_length, valid);
    end

endmodule
