`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg reset;
    wire [7:0] count_out;
    wire valid;
    wire value_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .count_out(count_out),
        .valid(valid),
        .value_out(value_out)
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
            test_num = test_num + 1;
            $display("\nTest %0d: Run of 5 zeros", test_num);
            reset_dut();


            repeat(5) begin
                data_in = 0;
                @(posedge clk);
            end


            data_in = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd5, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Run of 3 ones", test_num);
            reset_dut();


            repeat(3) begin
                data_in = 1;
                @(posedge clk);
            end


            data_in = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd3, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Alternating bits (0-1-0)", test_num);
            reset_dut();

            data_in = 0; @(posedge clk);
            data_in = 1; @(posedge clk);
            #1;
            if (valid && count_out == 8'd1 && value_out == 1'b0) begin

            end

            data_in = 0; @(posedge clk);
            #1 #1;
 check_outputs(8'd1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Long run of 20 zeros", test_num);
            reset_dut();

            repeat(20) begin
                data_in = 0;
                @(posedge clk);
            end

            data_in = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd20, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Reset mid-sequence", test_num);
            reset_dut();

            repeat(10) begin
                data_in = 1;
                @(posedge clk);
            end

            reset = 1;
            @(posedge clk);
            #1 reset = 0;


            data_in = 0;
            @(posedge clk);
            #1;
            if (valid == 1'b0) begin
                $display("PASS: No output valid immediately after reset");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Output valid should be low after reset");
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
        input expected_valid;
        input expected_value_out;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid) &&
                expected_value_out === (expected_value_out ^ value_out ^ expected_value_out)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h, valid=%b, value_out=%b",
                         count_out, valid, value_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h, valid=%b, value_out=%b",
                         expected_count_out, expected_valid, expected_value_out);
                $display("  Got:      count_out=%h, valid=%b, value_out=%b",
                         count_out, valid, value_out);
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
        $dumpvars(0,clk, data_in, reset, count_out, valid, value_out);
    end

endmodule
