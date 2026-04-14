`timescale 1ns/1ps

module LZW_Compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] symbol;
    reg valid;
    wire [11:0] codeword;
    wire valid_codeword;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LZW_Compressor dut (
        .clk(clk),
        .reset(reset),
        .symbol(symbol),
        .valid(valid),
        .codeword(codeword),
        .valid_codeword(valid_codeword)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            valid = 0;
            symbol = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Sequence (A, B, C)", test_num);
            reset_dut();

            @(posedge clk);
            symbol = 8'h41; valid = 1;
            @(posedge clk);
            symbol = 8'h42; valid = 1;
            @(posedge clk);
            symbol = 8'h43; valid = 1;
            @(posedge clk);
            valid = 0;
            #1;
            #1;

            check_outputs(12'h042, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Repeated Pattern (A, B, A, B, X)", test_num);
            reset_dut();

            @(posedge clk);
            symbol = 8'h41; valid = 1;
            @(posedge clk);
            symbol = 8'h42; valid = 1;
            @(posedge clk);
            symbol = 8'h41; valid = 1;
            @(posedge clk);
            symbol = 8'h42; valid = 1;
            @(posedge clk);
            symbol = 8'h58; valid = 1;
            @(posedge clk);
            valid = 0;
            #1;
            #1;

            check_outputs(12'd256, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Long Run (A, A, A, B)", test_num);
            reset_dut();

            @(posedge clk);
            symbol = 8'h41; valid = 1;
            @(posedge clk);
            symbol = 8'h41; valid = 1;
            @(posedge clk);
            symbol = 8'h41; valid = 1;
            @(posedge clk);
            symbol = 8'h42; valid = 1;
            @(posedge clk);
            valid = 0;
            #1;
            #1;

            check_outputs(12'd256, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Unique Numeric Sequence", test_num);
            reset_dut();

            @(posedge clk);
            symbol = 8'd0; valid = 1;
            @(posedge clk);
            symbol = 8'd1; valid = 1;
            @(posedge clk);
            symbol = 8'd2; valid = 1;
            @(posedge clk);
            symbol = 8'd3; valid = 1;
            @(posedge clk);
            valid = 0;
            #1;
            #1;

            check_outputs(12'd2, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LZW_Compressor Testbench");
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
        input [11:0] expected_codeword;
        input expected_valid_codeword;
        begin
            if (expected_codeword === (expected_codeword ^ codeword ^ expected_codeword) &&
                expected_valid_codeword === (expected_valid_codeword ^ valid_codeword ^ expected_valid_codeword)) begin
                $display("PASS");
                $display("  Outputs: codeword=%h, valid_codeword=%b",
                         codeword, valid_codeword);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: codeword=%h, valid_codeword=%b",
                         expected_codeword, expected_valid_codeword);
                $display("  Got:      codeword=%h, valid_codeword=%b",
                         codeword, valid_codeword);
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
        $dumpvars(0,clk, reset, symbol, valid, codeword, valid_codeword);
    end

endmodule
