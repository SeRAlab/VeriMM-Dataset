`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    reg rst;
    wire [7:0] count_out;
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
        .data_valid(data_valid),
        .rst(rst),
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
            data_in = 8'h0;
            data_valid = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic sequence (3 same, 1 different)", test_num);
            reset_dut();


            data_in = 8'hAA; data_valid = 1; @(posedge clk);
            data_in = 8'hAA; data_valid = 1; @(posedge clk);
            data_in = 8'hAA; data_valid = 1; @(posedge clk);


            data_in = 8'hBB; data_valid = 1; @(posedge clk);

            #1;
            #1;

            check_outputs(8'd3, 1'b1, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single value sequence", test_num);
            reset_dut();


            data_in = 8'h12; data_valid = 1; @(posedge clk);


            data_in = 8'h34; data_valid = 1; @(posedge clk);

            #1;
            #1;

            check_outputs(8'd1, 1'b1, 8'h12);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Long sequence (10 identical bytes)", test_num);
            reset_dut();

            repeat(10) begin
                data_in = 8'h55; data_valid = 1; @(posedge clk);
            end


            data_in = 8'h00; data_valid = 1; @(posedge clk);

            #1;
            #1;

            check_outputs(8'd10, 1'b1, 8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Intermittent data_valid", test_num);
            reset_dut();

            data_in = 8'hCC; data_valid = 1; @(posedge clk);
            data_in = 8'hCC; data_valid = 0; @(posedge clk);
            data_in = 8'hCC; data_valid = 0; @(posedge clk);
            data_in = 8'hCC; data_valid = 1; @(posedge clk);


            data_in = 8'hDD; data_valid = 1; @(posedge clk);

            #1;

            #1;


            check_outputs(8'd2, 1'b1, 8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verify no output while values are identical", test_num);
            reset_dut();

            data_in = 8'hFF; data_valid = 1; @(posedge clk);
            data_in = 8'hFF; data_valid = 1; @(posedge clk);
            data_in = 8'hFF; data_valid = 1; @(posedge clk);

            #1;

            #1;


            check_outputs(count_out, 1'b0, value_out);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Multiple consecutive runs", test_num);
            reset_dut();


            data_in = 8'h11; data_valid = 1; @(posedge clk);
            data_in = 8'h11; data_valid = 1; @(posedge clk);


            data_in = 8'h22; data_valid = 1; @(posedge clk);
            data_in = 8'h22; data_valid = 1; @(posedge clk);
            data_in = 8'h22; data_valid = 1; @(posedge clk);


            data_in = 8'h33; data_valid = 1; @(posedge clk);

            #1;

            #1;


            check_outputs(8'd3, 1'b1, 8'h22);
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
        input [7:0] expected_count_out;
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
        $dumpvars(0,clk, data_in, data_valid, rst, count_out, valid_out, value_out);
    end

endmodule
