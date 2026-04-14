`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    wire [7:0] run_length;
    wire valid;
    wire [7:0] value_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .run_length(run_length),
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
            data_in = 8'h0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple run of 5 identical values", test_num);
            reset_dut();


            repeat(5) begin
                data_in = 8'hAA;
                @(posedge clk);
            end


            data_in = 8'hBB;
            @(posedge clk);

            #1;
            #1;

            check_outputs(8'd5, 1'b1, 8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single byte runs (alternating)", test_num);
            reset_dut();


            data_in = 8'h11;
            @(posedge clk);
            data_in = 8'h22;
            @(posedge clk);
            data_in = 8'h33;
            @(posedge clk);

            #1;

            #1;


            check_outputs(8'd1, 1'b1, 8'h22);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum run length (255)", test_num);
            reset_dut();


            repeat(255) begin
                data_in = 8'hFF;
                @(posedge clk);
            end


            data_in = 8'h00;
            @(posedge clk);

            #1;
            #1;

            check_outputs(8'd255, 1'b1, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset during a run", test_num);
            reset_dut();


            repeat(10) begin
                data_in = 8'hCC;
                @(posedge clk);
            end


            reset = 1;
            @(posedge clk);
            reset = 0;


            repeat(3) begin
                data_in = 8'hDD;
                @(posedge clk);
            end
            data_in = 8'hEE;
            @(posedge clk);

            #1;


            #1;



            check_outputs(8'd3, 1'b1, 8'hDD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Run of 2 values", test_num);
            reset_dut();

            data_in = 8'h55;
            @(posedge clk);
            data_in = 8'h55;
            @(posedge clk);

            data_in = 8'h66;
            @(posedge clk);

            #1;
            #1;

            check_outputs(8'd2, 1'b1, 8'h55);
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
        input [7:0] expected_run_length;
        input expected_valid;
        input [7:0] expected_value_out;
        begin
            if (expected_run_length === (expected_run_length ^ run_length ^ expected_run_length) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid) &&
                expected_value_out === (expected_value_out ^ value_out ^ expected_value_out)) begin
                $display("PASS");
                $display("  Outputs: run_length=%h, valid=%b, value_out=%h",
                         run_length, valid, value_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: run_length=%h, valid=%b, value_out=%h",
                         expected_run_length, expected_valid, expected_value_out);
                $display("  Got:      run_length=%h, valid=%b, value_out=%h",
                         run_length, valid, value_out);
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
        $dumpvars(0,clk, data_in, reset, run_length, valid, value_out);
    end

endmodule
