`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    reg rst;
    wire output_valid;
    wire [7:0] run_length;
    wire [7:0] run_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .rst(rst),
        .output_valid(output_valid),
        .run_length(run_length),
        .run_value(run_value)
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
            data_valid = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple run of 5 identical values", test_num);
            reset_dut();


            repeat(5) begin
                data_in = 8'hAA;
                data_valid = 1;
                @(posedge clk);
            end


            data_in = 8'hBB;
            data_valid = 1;
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1, 8'd5, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Run of length 1", test_num);
            reset_dut();

            data_in = 8'h11;
            data_valid = 1;
            @(posedge clk);

            data_in = 8'h22;
            data_valid = 1;
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1, 8'd1, 8'h11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Run of length 15", test_num);
            reset_dut();

            repeat(15) begin
                data_in = 8'hCC;
                data_valid = 1;
                @(posedge clk);
            end

            data_in = 8'hDD;
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1, 8'd15, 8'hCC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple consecutive runs", test_num);
            reset_dut();


            repeat(3) begin
                data_in = 8'h01;
                data_valid = 1;
                @(posedge clk);
            end


            repeat(2) begin
                data_in = 8'h02;
                data_valid = 1;
                @(posedge clk);
            end


            data_in = 8'h03;
            @(posedge clk);

            #1;

            #1;


            check_outputs(1'b1, 8'd2, 8'h02);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Stream termination via data_valid=0", test_num);
            reset_dut();

            repeat(4) begin
                data_in = 8'hEE;
                data_valid = 1;
                @(posedge clk);
            end

            data_valid = 0;
            @(posedge clk);

            #1;

            #1;


            check_outputs(1'b1, 8'd4, 8'hEE);
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
        input expected_output_valid;
        input [7:0] expected_run_length;
        input [7:0] expected_run_value;
        begin
            if (expected_output_valid === (expected_output_valid ^ output_valid ^ expected_output_valid) &&
                expected_run_length === (expected_run_length ^ run_length ^ expected_run_length) &&
                expected_run_value === (expected_run_value ^ run_value ^ expected_run_value)) begin
                $display("PASS");
                $display("  Outputs: output_valid=%b, run_length=%h, run_value=%h",
                         output_valid, run_length, run_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_valid=%b, run_length=%h, run_value=%h",
                         expected_output_valid, expected_run_length, expected_run_value);
                $display("  Got:      output_valid=%b, run_length=%h, run_value=%h",
                         output_valid, run_length, run_value);
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
        $dumpvars(0,clk, data_in, data_valid, rst, output_valid, run_length, run_value);
    end

endmodule
