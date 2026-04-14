`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    reg rst;
    wire [7:0] bit_out;
    wire [7:0] count_out;
    wire data_out_valid;

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
        .bit_out(bit_out),
        .count_out(count_out),
        .data_out_valid(data_out_valid)
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
            data_valid = 1'b0;
            #20;
            @(posedge clk);
            rst = 0;
            @(posedge clk);
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 5 consecutive ones", test_num);
            reset_dut();

            data_in = 8'h01;
            data_valid = 1'b1;
            repeat(5) @(posedge clk);


            data_valid = 1'b0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h01, 8'd5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 10 consecutive zeros", test_num);
            reset_dut();

            data_in = 8'h00;
            data_valid = 1'b1;
            repeat(10) @(posedge clk);

            data_valid = 1'b0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h00, 8'd10, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single bit run", test_num);
            reset_dut();

            data_in = 8'h01;
            data_valid = 1'b1;
            @(posedge clk);

            data_valid = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h01, 8'd1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum 8-bit count (255)", test_num);
            reset_dut();

            data_in = 8'h01;
            data_valid = 1'b1;
            repeat(255) @(posedge clk);

            data_valid = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h01, 8'd255, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data ignored when valid is low", test_num);
            reset_dut();

            data_in = 8'h01;
            data_valid = 1'b1;
            repeat(3) @(posedge clk);

            data_valid = 1'b0;
            data_in = 8'h00;
            repeat(5) @(posedge clk);

            #1;

            #1;


            check_outputs(8'h01, 8'd3, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset state check", test_num);
            reset_dut();


            #1;



            check_outputs(8'h00, 8'h00, 1'b0);
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
        input [7:0] expected_bit_out;
        input [7:0] expected_count_out;
        input expected_data_out_valid;
        begin
            if (expected_bit_out === (expected_bit_out ^ bit_out ^ expected_bit_out) &&
                expected_count_out === (expected_count_out ^ count_out ^ expected_count_out) &&
                expected_data_out_valid === (expected_data_out_valid ^ data_out_valid ^ expected_data_out_valid)) begin
                $display("PASS");
                $display("  Outputs: bit_out=%h, count_out=%h, data_out_valid=%b",
                         bit_out, count_out, data_out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bit_out=%h, count_out=%h, data_out_valid=%b",
                         expected_bit_out, expected_count_out, expected_data_out_valid);
                $display("  Got:      bit_out=%h, count_out=%h, data_out_valid=%b",
                         bit_out, count_out, data_out_valid);
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
        $dumpvars(0,clk, data_in, data_valid, rst, bit_out, count_out, data_out_valid);
    end

endmodule
