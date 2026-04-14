`timescale 1ns/1ps

module lzw_compressor_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] char_in;
    reg clk;
    reg reset;
    wire [11:0] code_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lzw_compressor dut (
        .char_in(char_in),
        .clk(clk),
        .reset(reset),
        .code_out(code_out),
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
            char_in = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic transition...");
            reset_dut();

            @(posedge clk);
            char_in = 8'h41;

            @(posedge clk);
            char_in = 8'h42;


            while (!valid) @(posedge clk);

            #1;


            check_outputs(12'h041, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Dictionary Hit (AB)...");
            reset_dut();


            char_in = 8'h41; @(posedge clk);
            char_in = 8'h42; @(posedge clk);
            char_in = 8'h41; @(posedge clk);
            char_in = 8'h42; @(posedge clk);


            char_in = 8'h43;


            do @(posedge clk); while (!valid);

            #1;


            check_outputs(12'h100, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Repeated characters (AAAAA)...");
            reset_dut();

            char_in = 8'h41; @(posedge clk);
            char_in = 8'h41; @(posedge clk);
            char_in = 8'h41; @(posedge clk);
            char_in = 8'h41; @(posedge clk);
            char_in = 8'h42; @(posedge clk);


            while (!valid) @(posedge clk);

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
        input expected_valid;
        begin
            if (expected_code_out === (expected_code_out ^ code_out ^ expected_code_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: code_out=%h, valid=%b",
                         code_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: code_out=%h, valid=%b",
                         expected_code_out, expected_valid);
                $display("  Got:      code_out=%h, valid=%b",
                         code_out, valid);
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
        $dumpvars(0,char_in, clk, reset, code_out, valid);
    end

endmodule
