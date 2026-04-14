`timescale 1ns/1ps

module lzw_encoder_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] char_in;
    reg clk;
    reg reset;
    reg valid_in;
    wire [15:0] code_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lzw_encoder dut (
        .char_in(char_in),
        .clk(clk),
        .reset(reset),
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
            reset = 1;
            char_in = 0;
            valid_in = 0;
            repeat(5) @(posedge clk);
            #1;
            reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task send_char;

        input [7:0] char;
        begin
            @(posedge clk);
            #1;
            char_in = char;
            valid_in = 1;
            @(posedge clk);
            #1;
            valid_in = 0;

            repeat(3) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Single Character 'A'", test_num);
            reset_dut();
            send_char(8'h41);


            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h0041, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Sequence 'ABC'", test_num);
            reset_dut();
            send_char(8'h41);
            send_char(8'h42);
            send_char(8'h43);

            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'h0043, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Repeating Sequence 'AAAA'", test_num);
            reset_dut();
            send_char(8'h41);
            send_char(8'h41);
            send_char(8'h41);
            send_char(8'h41);

            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h0041, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Alternating Sequence 'ABAB'", test_num);
            reset_dut();
            send_char(8'h41);
            send_char(8'h42);
            send_char(8'h41);
            send_char(8'h42);

            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'd256, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lzw_encoder Testbench");
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
        input [15:0] expected_code_out;
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
        $dumpvars(0,char_in, clk, reset, valid_in, code_out, valid_out);
    end

endmodule
