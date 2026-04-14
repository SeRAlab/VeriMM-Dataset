`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg bit_in;
    reg clk;
    reg rst;
    wire [7:0] run_length;
    wire [7:0] run_value;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .bit_in(bit_in),
        .clk(clk),
        .rst(rst),
        .run_length(run_length),
        .run_value(run_value),
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
            bit_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: 3 consecutive 1s then change", test_num);
            reset_dut();
            bit_in = 1;
            repeat(3) @(posedge clk);
            bit_in = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd3, 8'd1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: 5 consecutive 0s then change", test_num);
            reset_dut();
            bit_in = 0;
            repeat(5) @(posedge clk);
            bit_in = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd5, 8'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Maximum run length (8 ones)", test_num);
            reset_dut();
            bit_in = 1;
            repeat(7) @(posedge clk);

            @(posedge clk);
            #1 #1;
 check_outputs(8'd8, 8'd1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Split run at max length (9 zeros)", test_num);
            reset_dut();
            bit_in = 0;
            repeat(8) @(posedge clk);

            #1 #1;
 check_outputs(8'd8, 8'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Single bit run (1 then 0)", test_num);
            reset_dut();
            bit_in = 1;
            @(posedge clk);
            bit_in = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd1, 8'd1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Reset mid-run", test_num);
            reset_dut();
            bit_in = 1;
            repeat(4) @(posedge clk);
            rst = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd0, 8'd0, 1'b0);
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
        input [7:0] expected_run_length;
        input [7:0] expected_run_value;
        input expected_valid;
        begin
            if (expected_run_length === (expected_run_length ^ run_length ^ expected_run_length) &&
                expected_run_value === (expected_run_value ^ run_value ^ expected_run_value) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: run_length=%h, run_value=%h, valid=%b",
                         run_length, run_value, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: run_length=%h, run_value=%h, valid=%b",
                         expected_run_length, expected_run_value, expected_valid);
                $display("  Got:      run_length=%h, run_value=%h, valid=%b",
                         run_length, run_value, valid);
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
        $dumpvars(0,bit_in, clk, rst, run_length, run_value, valid);
    end

endmodule
