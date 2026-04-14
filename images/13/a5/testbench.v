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
            data_in = 8'h0;
            data_valid = 0;
            repeat(5) @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task send_byte;

        input [7:0] b;
        begin
            data_in = b;
            data_valid = 1;
            @(posedge clk);
            data_valid = 0;



            repeat(2) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Basic Sequence 'AB'...", test_num);
            reset_dut();

            send_byte(8'h41);
            send_byte(8'h42);


            while (!code_valid) @(posedge clk);

            #1;


            check_outputs(12'h041, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Repeating Pattern (Dict Hit)...", test_num);
            reset_dut();

            send_byte(8'h61);
            send_byte(8'h61);


            while(code_valid) @(posedge clk);

            send_byte(8'h61);
            send_byte(8'h62);


            while (!code_valid) @(posedge clk);

            #1;


            check_outputs(12'h100, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Multi-step Dict Growth...", test_num);
            reset_dut();

            send_byte(8'h01);
            send_byte(8'h02);
            send_byte(8'h01);
            send_byte(8'h02);
            send_byte(8'h03);


            repeat(20) begin
                if (code_valid && code_out == 12'h100) break;
                @(posedge clk);
            end

            #1;


            check_outputs(12'h100, 1'b1);
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
