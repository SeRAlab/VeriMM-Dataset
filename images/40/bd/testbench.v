`timescale 1ns/1ps

module LZW_Encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg valid_in;
    wire [11:0] encoded_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LZW_Encoder dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid_in(valid_in),
        .encoded_out(encoded_out),
        .valid_out(valid_out)
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
            repeat(2) @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task drive_input;

        input [7:0] d;
        begin
            data_in = d;
            valid_in = 1;
            @(posedge clk);
            #1;
        end
        endtask

    task finish_input;

        begin
            valid_in = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask

    task wait_for_valid;

        begin : wait_block
            integer timeout;
            timeout = 0;
            while (!valid_out && timeout < 50) begin
                @(posedge clk);
                timeout = timeout + 1;
            end
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase001: Sequence ABAB...");
            drive_input(8'h41);
            drive_input(8'h42);
            drive_input(8'h41);
            drive_input(8'h42);
            finish_input();


            wait_for_valid();
            #1;

            check_outputs(12'h100, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase002: Sequence AAAAA...");
            drive_input(8'h61);
            drive_input(8'h61);
            drive_input(8'h61);
            drive_input(8'h61);
            drive_input(8'h61);
            finish_input();


            wait_for_valid();
            #1;

            check_outputs(12'h100, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase003: Sequence 01, 02, 03...");
            drive_input(8'h01);
            drive_input(8'h02);
            drive_input(8'h03);
            finish_input();

            wait_for_valid();
            #1;

            check_outputs(12'h003, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LZW_Encoder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        
        
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
        input [11:0] expected_encoded_out;
        input expected_valid_out;
        begin
            if (expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: encoded_out=%h, valid_out=%b",
                         encoded_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out=%h, valid_out=%b",
                         expected_encoded_out, expected_valid_out);
                $display("  Got:      encoded_out=%h, valid_out=%b",
                         encoded_out, valid_out);
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
        $dumpvars(0,clk, data_in, rst, valid_in, encoded_out, valid_out);
    end

endmodule
