`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg valid_in;
    wire [7:0] encoded_value;
    wire [3:0] run_length;
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
        .valid_in(valid_in),
        .encoded_value(encoded_value),
        .run_length(run_length),
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
            data_in = 8'h0;
            valid_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Run (5 identical values)", test_num);
            reset_dut();


            repeat(5) begin
                @(posedge clk);
                data_in = 8'hA5;
                valid_in = 1;
            end


            @(posedge clk);
            data_in = 8'hBB;
            valid_in = 1;



            #1;
            #1;

            check_outputs(8'hA5, 4'd5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum Run Length (15 values)", test_num);
            reset_dut();


            repeat(15) begin
                @(posedge clk);
                data_in = 8'hCC;
                valid_in = 1;
            end


            @(posedge clk);
            data_in = 8'hDD;
            valid_in = 1;

            #1;
            #1;

            check_outputs(8'hCC, 4'd15, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Exceeding Max Run (16 values)", test_num);
            reset_dut();


            repeat(15) begin
                @(posedge clk);
                data_in = 8'hEE;
                valid_in = 1;
            end



            @(posedge clk);
            data_in = 8'hEE;
            valid_in = 1;

            #1;
            #1;

            check_outputs(8'hEE, 4'd15, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Values Sequence", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'h11;
            valid_in = 1;

            @(posedge clk);
            data_in = 8'h22;
            valid_in = 1;

            #1;
            #1;

            check_outputs(8'h11, 4'd1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: valid_in Gating Test", test_num);
            reset_dut();

            @(posedge clk);
            data_in = 8'hFF;
            valid_in = 1;

            @(posedge clk);
            data_in = 8'hFF;
            valid_in = 0;

            @(posedge clk);
            data_in = 8'h00;
            valid_in = 0;

            @(posedge clk);
            data_in = 8'hFF;
            valid_in = 1;

            @(posedge clk);
            data_in = 8'hAA;
            valid_in = 1;

            #1;
            #1;

            check_outputs(8'hFF, 4'd2, 1'b1);
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
        input [7:0] expected_encoded_value;
        input [3:0] expected_run_length;
        input expected_valid_out;
        begin
            if (expected_encoded_value === (expected_encoded_value ^ encoded_value ^ expected_encoded_value) &&
                expected_run_length === (expected_run_length ^ run_length ^ expected_run_length) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: encoded_value=%h, run_length=%h, valid_out=%b",
                         encoded_value, run_length, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_value=%h, run_length=%h, valid_out=%b",
                         expected_encoded_value, expected_run_length, expected_valid_out);
                $display("  Got:      encoded_value=%h, run_length=%h, valid_out=%b",
                         encoded_value, run_length, valid_out);
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
        $dumpvars(0,clk, data_in, reset, valid_in, encoded_value, run_length, valid_out);
    end

endmodule
