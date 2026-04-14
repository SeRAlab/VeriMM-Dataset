`timescale 1ns/1ps

module lzw_compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    reg rst;
    wire [11:0] code_out;
    wire code_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lzw_compressor dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .rst(rst),
        .code_out(code_out),
        .code_valid(code_valid)
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
            data_valid = 0;
            repeat (5) @(posedge clk);
            rst = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task send_byte;

        input [7:0] value;
        begin
            @(posedge clk);
            data_in = value;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;
        end
        endtask

    task testcase001;

        begin
            $display("\nRunning testcase001: Literal Sequence 'A', 'B'...");
            reset_dut();
            send_byte(8'h41);
            send_byte(8'h42);


            repeat (2) @(posedge clk);
            #1;

            check_outputs(12'h041, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Dictionary Hit Pattern 'A', 'A', 'A', 'B'...");
            reset_dut();
            send_byte(8'h41);
            send_byte(8'h41);
            send_byte(8'h41);
            send_byte(8'h42);


            repeat (2) @(posedge clk);
            #1;

            check_outputs(12'h100, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Overlapping Sequence 'A', 'B', 'A', 'B', 'C'...");
            reset_dut();
            send_byte(8'h41);
            send_byte(8'h42);
            send_byte(8'h41);
            send_byte(8'h42);
            send_byte(8'h43);

            repeat (2) @(posedge clk);
            #1;

            check_outputs(12'h100, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Continuous Literals '1', '2', '3'...");
            reset_dut();
            send_byte(8'h31);
            send_byte(8'h32);
            send_byte(8'h33);

            repeat (2) @(posedge clk);
            #1;

            check_outputs(12'h032, 1'b1);
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
        input expected_code_valid;
        begin
            if (expected_code_out === (expected_code_out ^ code_out ^ expected_code_out) &&
                expected_code_valid === (expected_code_valid ^ code_valid ^ expected_code_valid)) begin
                $display("PASS");
                $display("  Outputs: code_out=%h, code_valid=%b",
                         code_out, code_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: code_out=%h, code_valid=%b",
                         expected_code_out, expected_code_valid);
                $display("  Got:      code_out=%h, code_valid=%b",
                         code_out, code_valid);
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
        $dumpvars(0,clk, data_in, data_valid, rst, code_out, code_valid);
    end

endmodule
