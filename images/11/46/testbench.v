`timescale 1ns/1ps

module lzw_compressor_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] char_in;
    reg clk;
    reg reset;
    reg start;
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
        .start(start),
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
            start = 0;
            char_in = 0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Single Character 'A'", test_num);
            reset_dut();


            start = 1;
            char_in = 8'h41;
            @(posedge clk);


            start = 0;
            char_in = 8'h00;


            wait(valid == 1);
            #1;

            check_outputs(12'h041, 1'b1);
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Sequence 'AB'", test_num);
            reset_dut();

            start = 1;
            char_in = 8'h41;
            @(posedge clk);
            char_in = 8'h42;
            @(posedge clk);

            start = 0;




            repeat(10) begin
                @(posedge clk);
                if (valid && code_out == 12'h042) break;
            end

            #1;


            check_outputs(12'h042, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Compressed Sequence 'ABAB'", test_num);
            reset_dut();

            start = 1;
            char_in = 8'h41; @(posedge clk);
            char_in = 8'h42; @(posedge clk);
            char_in = 8'h41; @(posedge clk);
            char_in = 8'h42; @(posedge clk);
            start = 0;



            repeat(20) begin
                @(posedge clk);
                if (valid && code_out == 12'h100) break;
            end

            #1;


            check_outputs(12'h100, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Repeated Characters 'AAAA'", test_num);
            reset_dut();

            start = 1;
            char_in = 8'h41; @(posedge clk);
            char_in = 8'h41; @(posedge clk);
            char_in = 8'h41; @(posedge clk);
            char_in = 8'h41; @(posedge clk);
            start = 0;


            repeat(20) begin
                @(posedge clk);
                if (valid && code_out == 12'h041) begin

                     break;
                end
            end

            #1;


            check_outputs(12'h041, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Reset Mid-Process", test_num);
            reset_dut();

            start = 1;
            char_in = 8'h58; @(posedge clk);
            char_in = 8'h58; @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;
            start = 1;
            char_in = 8'h43; @(posedge clk);
            start = 0;

            wait(valid == 1);
            #1;

            check_outputs(12'h043, 1'b1);
            @(posedge clk);
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
        $dumpvars(0,char_in, clk, reset, start, code_out, valid);
    end

endmodule
