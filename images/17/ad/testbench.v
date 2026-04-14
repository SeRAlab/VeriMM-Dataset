`timescale 1ns/1ps

module lzw_compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg valid_in;
    wire [11:0] code_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lzw_compressor dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .valid_in(valid_in),
        .code_out(code_out),
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
            data_in = 0;
            valid_in = 0;
            repeat(2) @(posedge clk);
            rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task send_byte;

        input [7:0] val;
        begin
            data_in = val;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;
        end
        endtask

    task testcase001;

        begin
            $display("\nRunning testcase001: Literal Output...");
            test_num = 1;
            reset_dut();

            send_byte(8'h41);
            send_byte(8'h42);


            while (!valid_out) @(posedge clk);
            #1;

            check_outputs(12'h041, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Compression Check...");
            test_num = 2;
            reset_dut();

            send_byte(8'h41);
            send_byte(8'h41);


            while (!valid_out) @(posedge clk);

            send_byte(8'h41);
            send_byte(8'h42);


            while (!valid_out) @(posedge clk);
            #1;

            check_outputs(12'h100, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Multiple Dictionary Entries...");
            test_num = 3;
            reset_dut();

            send_byte(8'h01);
            send_byte(8'h02);
            while (!valid_out) @(posedge clk);

            send_byte(8'h01);
            while (!valid_out) @(posedge clk);

            send_byte(8'h02);
            send_byte(8'h03);
            while (!valid_out) @(posedge clk);

            #1;


            check_outputs(12'h100, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Dictionary Reset...");
            test_num = 4;
            reset_dut();


            send_byte(8'h58);
            send_byte(8'h59);
            while (!valid_out) @(posedge clk);


            reset_dut();



            send_byte(8'h58);
            send_byte(8'h59);
            while (!valid_out) @(posedge clk);

            #1;


            check_outputs(12'h058, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lzw_compressor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [11:0] expected_code_out;
        input expected_valid_out;
        begin
            if (expected_code_out === (expected_code_out ^ code_out ^ expected_code_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: code_out=%h, valid_out=%b",
                         code_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: code_out=%h, valid_out=%b",
                         expected_code_out, expected_valid_out);
                $display("  Got:      code_out=%h, valid_out=%b",
                         code_out, valid_out);
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
        $dumpvars(0,clk, data_in, rst, valid_in, code_out, valid_out);
    end

endmodule
