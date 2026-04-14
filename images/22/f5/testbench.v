`timescale 1ns/1ps

module viterbi_decoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] received_bits;
    reg reset;
    wire [3:0] decoded_bits;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    viterbi_decoder dut (
        .clk(clk),
        .received_bits(received_bits),
        .reset(reset),
        .decoded_bits(decoded_bits),
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
            received_bits = 2'b00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: All Zeros Sequence");
            reset_dut();


            received_bits = 2'b00; @(posedge clk); #1;

            received_bits = 2'b00; @(posedge clk); #1;

            received_bits = 2'b00; @(posedge clk); #1;

            received_bits = 2'b00; @(posedge clk); #1;

            wait(valid);
            #1;

            check_outputs(4'b0000, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All Ones Sequence");
            reset_dut();

            received_bits = 2'b11; @(posedge clk); #1;
            received_bits = 2'b01; @(posedge clk); #1;
            received_bits = 2'b01; @(posedge clk); #1;
            received_bits = 2'b01; @(posedge clk); #1;

            wait(valid);
            #1;

            check_outputs(4'b1111, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Error Correction (Single bit flip)");
            reset_dut();

            received_bits = 2'b01; @(posedge clk); #1;
            received_bits = 2'b00; @(posedge clk); #1;
            received_bits = 2'b00; @(posedge clk); #1;
            received_bits = 2'b00; @(posedge clk); #1;

            wait(valid);

            #1;


            check_outputs(4'b0000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Alternating 1010 Sequence");
            reset_dut();

            received_bits = 2'b11; @(posedge clk); #1;
            received_bits = 2'b10; @(posedge clk); #1;
            received_bits = 2'b11; @(posedge clk); #1;
            received_bits = 2'b10; @(posedge clk); #1;

            wait(valid);
            #1;

            check_outputs(4'b1010, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: High Noise Correction");
            reset_dut();

            received_bits = 2'b11; @(posedge clk); #1;
            received_bits = 2'b11; @(posedge clk); #1;
            received_bits = 2'b01; @(posedge clk); #1;
            received_bits = 2'b00; @(posedge clk); #1;

            wait(valid);
            #1;

            check_outputs(4'b1111, 1'b1);
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
        input [3:0] expected_decoded_bits;
        input expected_valid;
        begin
            if (expected_decoded_bits === (expected_decoded_bits ^ decoded_bits ^ expected_decoded_bits) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: decoded_bits=%h, valid=%b",
                         decoded_bits, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_bits=%h, valid=%b",
                         expected_decoded_bits, expected_valid);
                $display("  Got:      decoded_bits=%h, valid=%b",
                         decoded_bits, valid);
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
        $dumpvars(0,clk, received_bits, reset, decoded_bits, valid);
    end

endmodule
