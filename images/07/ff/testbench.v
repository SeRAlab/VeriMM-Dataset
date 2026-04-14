`timescale 1ns/1ps

module viterbi_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] encoded_bit;
    reg reset;
    reg valid_in;
    wire [3:0] decoded_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    viterbi_decoder dut (
        .clk(clk),
        .encoded_bit(encoded_bit),
        .reset(reset),
        .valid_in(valid_in),
        .decoded_out(decoded_out),
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
            valid_in = 0;
            encoded_bit = 2'b00;
            repeat(5) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: All Zeros Sequence");
            reset_dut();


            repeat(4) begin
                @(posedge clk);
                #1;
                valid_in = 1;
                encoded_bit = 2'b00;
            end

            @(posedge clk);
            #1 valid_in = 0;


            wait(valid_out === 1);
            @(posedge clk);
            #1;

            check_outputs(4'b0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Sequence 1011");
            reset_dut();

            @(posedge clk); #1 valid_in = 1; encoded_bit = 2'b11;
            @(posedge clk); #1 valid_in = 1; encoded_bit = 2'b10;
            @(posedge clk); #1 valid_in = 1; encoded_bit = 2'b00;
            @(posedge clk); #1 valid_in = 1; encoded_bit = 2'b01;

            @(posedge clk); #1 valid_in = 0;

            wait(valid_out === 1);
            @(posedge clk);
            #1;

            check_outputs(4'b1011, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Error Correction (1100 with 1-bit error)");
            reset_dut();

            @(posedge clk); #1 valid_in = 1; encoded_bit = 2'b11;
            @(posedge clk); #1 valid_in = 1; encoded_bit = 2'b00;
            @(posedge clk); #1 valid_in = 1; encoded_bit = 2'b01;
            @(posedge clk); #1 valid_in = 1; encoded_bit = 2'b11;

            @(posedge clk); #1 valid_in = 0;

            wait(valid_out === 1);
            @(posedge clk);
            #1;

            check_outputs(4'b1100, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Alternating Sequence 1010");
            reset_dut();

            @(posedge clk); #1 valid_in = 1; encoded_bit = 2'b11;
            @(posedge clk); #1 valid_in = 1; encoded_bit = 2'b10;
            @(posedge clk); #1 valid_in = 1; encoded_bit = 2'b00;
            @(posedge clk); #1 valid_in = 1; encoded_bit = 2'b10;

            @(posedge clk); #1 valid_in = 0;

            wait(valid_out === 1);
            @(posedge clk);
            #1;

            check_outputs(4'b1010, 1'b1);
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
        input [3:0] expected_decoded_out;
        input expected_valid_out;
        begin
            if (expected_decoded_out === (expected_decoded_out ^ decoded_out ^ expected_decoded_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: decoded_out=%h, valid_out=%b",
                         decoded_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_out=%h, valid_out=%b",
                         expected_decoded_out, expected_valid_out);
                $display("  Got:      decoded_out=%h, valid_out=%b",
                         decoded_out, valid_out);
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
        $dumpvars(0,clk, encoded_bit, reset, valid_in, decoded_out, valid_out);
    end

endmodule
