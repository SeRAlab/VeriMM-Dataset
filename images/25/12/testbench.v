`timescale 1ns/1ps

module checksum_checker_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] checksum_in;
    reg clk;
    reg [7:0] data_in;
    reg data_ready;
    reg reset;
    wire [7:0] checksum_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum_checker dut (
        .checksum_in(checksum_in),
        .clk(clk),
        .data_in(data_in),
        .data_ready(data_ready),
        .reset(reset),
        .checksum_out(checksum_out),
        .valid(valid)
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
            data_ready = 0;
            checksum_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Single byte matching checksum...");
            test_num = 1;
            reset_dut();

            data_in = 8'hA5;
            checksum_in = 8'hA5;
            data_ready = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Multiple bytes matching checksum...");
            test_num = 2;
            reset_dut();

            data_in = 8'h10;
            @(posedge clk); #1;
            data_in = 8'h20;
            @(posedge clk); #1;
            data_in = 8'h30;
            checksum_in = 8'h60;
            data_ready = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h60, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Checksum overflow (Modulo 256)...");
            test_num = 3;
            reset_dut();

            data_in = 8'hFF;
            @(posedge clk); #1;
            data_in = 8'h02;
            checksum_in = 8'h01;
            data_ready = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Checksum mismatch (Invalid flag)...");
            test_num = 4;
            reset_dut();

            data_in = 8'h55;
            @(posedge clk); #1;
            data_in = 8'hAA;
            checksum_in = 8'h00;
            data_ready = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Zero value input...");
            test_num = 5;
            reset_dut();

            data_in = 8'h00;
            checksum_in = 8'h00;
            data_ready = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("checksum_checker Testbench");
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
        input [7:0] expected_checksum_out;
        input expected_valid;
        begin
            if (expected_checksum_out === (expected_checksum_out ^ checksum_out ^ expected_checksum_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: checksum_out=%h, valid=%b",
                         checksum_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_out=%h, valid=%b",
                         expected_checksum_out, expected_valid);
                $display("  Got:      checksum_out=%h, valid=%b",
                         checksum_out, valid);
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
        $dumpvars(0,checksum_in, clk, data_in, data_ready, reset, checksum_out, valid);
    end

endmodule
