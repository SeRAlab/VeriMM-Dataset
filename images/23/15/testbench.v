`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg valid_in;
    wire [3:0] count_out;
    wire valid_out;
    wire [7:0] value_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid_in(valid_in),
        .count_out(count_out),
        .valid_out(valid_out),
        .value_out(value_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            valid_in = 0;
            data_in = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic sequence of 3 identical bytes", test_num);
            reset_dut();


            @(posedge clk);
            valid_in = 1;
            data_in = 8'hAA;
            @(posedge clk);
            @(posedge clk);


            data_in = 8'hBB;


            wait(valid_out == 1);
            #1;

            check_outputs(4'd3, 1'b1, 8'hAA);
            @(posedge clk);
            valid_in = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single byte run", test_num);
            reset_dut();


            @(posedge clk);
            valid_in = 1;
            data_in = 8'h55;


            @(posedge clk);
            data_in = 8'h66;

            wait(valid_out == 1);
            #1;

            check_outputs(4'd1, 1'b1, 8'h55);
            @(posedge clk);
            valid_in = 0;
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum 4-bit count (15)", test_num);
            reset_dut();


            @(posedge clk);
            valid_in = 1;
            data_in = 8'hFF;
            for (i = 0; i < 14; i = i + 1) begin
                @(posedge clk);
            end


            data_in = 8'h00;

            wait(valid_out == 1);
            #1;

            check_outputs(4'd15, 1'b1, 8'hFF);
            @(posedge clk);
            valid_in = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Handling valid_in signal", test_num);
            reset_dut();


            @(posedge clk);
            valid_in = 1;
            data_in = 8'hCC;


            @(posedge clk);
            valid_in = 0;
            @(posedge clk);
            @(posedge clk);


            valid_in = 1;
            data_in = 8'hCC;
            @(posedge clk);


            data_in = 8'hDD;

            wait(valid_out == 1);

            #1;


            check_outputs(4'd2, 1'b1, 8'hCC);
            @(posedge clk);
            valid_in = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating values", test_num);
            reset_dut();


            @(posedge clk);
            valid_in = 1;
            data_in = 8'h11;


            @(posedge clk);
            data_in = 8'h22;

            wait(valid_out == 1);
            #1;

            check_outputs(4'd1, 1'b1, 8'h11);


            @(posedge clk);
            data_in = 8'h33;

            wait(valid_out == 1);
            #1;

            check_outputs(4'd1, 1'b1, 8'h22);

            @(posedge clk);
            valid_in = 0;
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
        input [3:0] expected_count_out;
        input expected_valid_out;
        input [7:0] expected_value_out;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out) &&
                expected_value_out === (expected_value_out ^ value_out ^ expected_value_out)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h, valid_out=%b, value_out=%h",
                         count_out, valid_out, value_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h, valid_out=%b, value_out=%h",
                         expected_count_out, expected_valid_out, expected_value_out);
                $display("  Got:      count_out=%h, valid_out=%b, value_out=%h",
                         count_out, valid_out, value_out);
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
        $dumpvars(0,clk, data_in, rst, valid_in, count_out, valid_out, value_out);
    end

endmodule
