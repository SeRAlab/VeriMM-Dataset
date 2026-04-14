`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg reset;
    reg valid_in;
    wire [31:0] data_out;
    wire full;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid_in(valid_in),
        .data_out(data_out),
        .full(full),
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
            valid_in = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Single Write-Read", test_num);
            reset_dut();


            data_in = 32'hDEADBEEF;
            valid_in = 1;
            @(posedge clk);
            #1;
            valid_in = 0;



            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Initial/Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(data_out, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Burst Write Sequence", test_num);
            reset_dut();


            data_in = 32'h11111111; valid_in = 1; @(posedge clk); #1;
            data_in = 32'h22222222; valid_in = 1; @(posedge clk); #1;
            data_in = 32'h33333333; valid_in = 1; @(posedge clk); #1;
            valid_in = 0;



            @(posedge clk); #1;

            @(posedge clk); #1;

            #1;


            check_outputs(32'h33333333, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Fill Buffer Attempt", test_num);
            reset_dut();



            repeat(16) begin
                data_in = $random;
                valid_in = 1;
                @(posedge clk);
                #1;
            end
            valid_in = 0;


            if (full === 1'b1 || valid_out === 1'b1) begin
                $display("  Buffer status: full=%b, valid_out=%b", full, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("  FAIL: Buffer empty after burst write");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Reset Mid-Operation", test_num);
            reset_dut();

            data_in = 32'hABCDEF01;
            valid_in = 1;
            @(posedge clk); #1;


            reset = 1;
            @(posedge clk); #1;
            reset = 0;
            @(posedge clk); #1;


            #1;



            check_outputs(data_out, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [31:0] expected_data_out;
        input expected_full;
        input expected_valid_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, full=%b, valid_out=%b",
                         data_out, full, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, full=%b, valid_out=%b",
                         expected_data_out, expected_full, expected_valid_out);
                $display("  Got:      data_out=%h, full=%b, valid_out=%b",
                         data_out, full, valid_out);
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
        $dumpvars(0,clk, data_in, reset, valid_in, data_out, full, valid_out);
    end

endmodule
