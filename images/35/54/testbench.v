`timescale 1ns/1ps

module rs_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg start;
    wire [6:0] encoded_out;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rs_encoder dut (
        .clk(clk),
        .data_in(data_in),
        .start(start),
        .encoded_out(encoded_out),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start <= 0;
            data_in <= 4'b0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test Case 001: Data In = 4'h0");
            data_in <= 4'h0;
            start <= 1;
            @(posedge clk);
            start <= 0;


            wait(ready == 1);

            #1;


            check_outputs(7'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test Case 002: Data In = 4'hF");
            data_in <= 4'hF;
            start <= 1;
            @(posedge clk);
            start <= 0;

            wait(ready == 1);


            #1;



            check_outputs(encoded_out, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test Case 003: Data In = 4'hA");
            data_in <= 4'hA;
            start <= 1;
            @(posedge clk);
            start <= 0;

            wait(ready == 1);
            #1;

            check_outputs(encoded_out, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test Case 004: Data In = 4'h5");
            data_in <= 4'h5;
            start <= 1;
            @(posedge clk);
            start <= 0;

            wait(ready == 1);
            #1;

            check_outputs(encoded_out, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test Case 005: Data In = 4'h1");
            data_in <= 4'h1;
            start <= 1;
            @(posedge clk);
            start <= 0;

            wait(ready == 1);
            #1;

            check_outputs(encoded_out, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test Case 006: Back-to-back start check");
            data_in <= 4'h3;
            start <= 1;
            @(posedge clk);
            start <= 0;
            wait(ready == 1);


            data_in <= 4'hC;
            start <= 1;
            @(posedge clk);
            start <= 0;
            wait(ready == 1);

            #1;


            check_outputs(encoded_out, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rs_encoder Testbench");
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
        input [6:0] expected_encoded_out;
        input expected_ready;
        begin
            if (expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: encoded_out=%h, ready=%b",
                         encoded_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out=%h, ready=%b",
                         expected_encoded_out, expected_ready);
                $display("  Got:      encoded_out=%h, ready=%b",
                         encoded_out, ready);
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
        $dumpvars(0,clk, data_in, start, encoded_out, ready);
    end

endmodule
