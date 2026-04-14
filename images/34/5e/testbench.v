`timescale 1ns/1ps

module viterbi_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] input_bits;
    reg rst;
    wire [4:0] decoded_bits;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    viterbi_decoder dut (
        .clk(clk),
        .input_bits(input_bits),
        .rst(rst),
        .decoded_bits(decoded_bits)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            input_bits = 5'b0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case 001: All Zeros");
            input_bits = 5'b00000;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case 002: All Ones");
            input_bits = 5'b11111;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case 003: Alternating 10101");
            input_bits = 5'b10101;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case 004: Single Bit Pulse 00100");
            input_bits = 5'b00100;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(5'b00100);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case 005: Pattern 11001");
            input_bits = 5'b11001;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(5'b11001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("viterbi_decoder Testbench");
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
        input [4:0] expected_decoded_bits;
        begin
            if (expected_decoded_bits === (expected_decoded_bits ^ decoded_bits ^ expected_decoded_bits)) begin
                $display("PASS");
                $display("  Outputs: decoded_bits=%h",
                         decoded_bits);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_bits=%h",
                         expected_decoded_bits);
                $display("  Got:      decoded_bits=%h",
                         decoded_bits);
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
        $dumpvars(0,clk, input_bits, rst, decoded_bits);
    end

endmodule
