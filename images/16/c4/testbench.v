`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    reg rst;
    wire bit_value;
    wire done;
    wire output_valid;
    wire [7:0] run_length;

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
        .bit_value(bit_value),
        .done(done),
        .output_valid(output_valid),
        .run_length(run_length)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 8'h00;
            data_valid = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\n--- Testcase 001: All Zeros (8'h00) ---");
            reset_dut();

            @(posedge clk);
            data_in = 8'b00000000;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;


            while (!output_valid) @(posedge clk);
            test_num = test_num + 1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 8'd8);


            repeat (5) @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            $display("\n--- Testcase 002: All Ones (8'hFF) ---");
            reset_dut();

            @(posedge clk);
            data_in = 8'b11111111;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;

            while (!output_valid) @(posedge clk);
            test_num = test_num + 1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1, 8'd8);

            repeat (5) @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            $display("\n--- Testcase 003: Mixed Bits (0xF0) ---");
            reset_dut();

            @(posedge clk);
            data_in = 8'b11110000;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;


            while (!output_valid) @(posedge clk);
            test_num = test_num + 1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1, 8'd4);


            @(posedge clk);
            while (!output_valid) @(posedge clk);
            test_num = test_num + 1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 8'd4);

            repeat (5) @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            $display("\n--- Testcase 004: Run spanning across bytes (0xFF, 0xF0) ---");
            reset_dut();


            @(posedge clk);
            data_in = 8'b11111111;
            data_valid = 1;
            @(posedge clk);


            data_in = 8'b11110000;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;


            while (!output_valid) @(posedge clk);
            test_num = test_num + 1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1, 8'd12);


            @(posedge clk);
            while (!output_valid) @(posedge clk);
            test_num = test_num + 1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 8'd4);

            repeat (5) @(posedge clk);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("\n--- Testcase 005: Alternating Bits (0xAA) ---");
            reset_dut();

            @(posedge clk);
            data_in = 8'b10101010;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;

            for (i = 0; i < 8; i = i + 1) begin
                while (!output_valid) @(posedge clk);
                test_num = test_num + 1;

                #1;


                check_outputs((i % 2 == 0), 1'b0, 1'b1, 8'd1);
                @(posedge clk);
            end

            repeat (5) @(posedge clk);
        end
        endtask

    task testcase006;

        begin
            $display("\n--- Testcase 006: Check Done Signal ---");
            reset_dut();

            @(posedge clk);
            data_in = 8'hFF;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;


            while (!output_valid) @(posedge clk);
            @(posedge clk);



            while (!done) @(posedge clk);
            test_num = test_num + 1;

            if (done === 1'b1) begin
                $display("PASS: done signal asserted");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: done signal not asserted");
                fail_count = fail_count + 1;
            end
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
        input expected_bit_value;
        input expected_done;
        input expected_output_valid;
        input [7:0] expected_run_length;
        begin
            if (expected_bit_value === (expected_bit_value ^ bit_value ^ expected_bit_value) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_output_valid === (expected_output_valid ^ output_valid ^ expected_output_valid) &&
                expected_run_length === (expected_run_length ^ run_length ^ expected_run_length)) begin
                $display("PASS");
                $display("  Outputs: bit_value=%b, done=%b, output_valid=%b, run_length=%h",
                         bit_value, done, output_valid, run_length);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bit_value=%b, done=%b, output_valid=%b, run_length=%h",
                         expected_bit_value, expected_done, expected_output_valid, expected_run_length);
                $display("  Got:      bit_value=%b, done=%b, output_valid=%b, run_length=%h",
                         bit_value, done, output_valid, run_length);
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
        $dumpvars(0,clk, data_in, data_valid, rst, bit_value, done, output_valid, run_length);
    end

endmodule
