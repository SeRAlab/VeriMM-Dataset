`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg nextWord;
    reg prevWord;
    reg [255:0] sentence;
    wire [31:0] currentWord;
    wire [2:0] wordIndex;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .nextWord(nextWord),
        .prevWord(prevWord),
        .sentence(sentence),
        .currentWord(currentWord),
        .wordIndex(wordIndex)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            nextWord = 0;
            prevWord = 0;
            sentence = {32'h00000007, 32'h00000006, 32'h00000005, 32'h00000004,
                        32'h00000003, 32'h00000002, 32'h00000001, 32'h00000000};

            repeat(8) begin
                prevWord = 1;
                @(posedge clk);
                #1;
                prevWord = 0;
            end
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(32'h00000007, 3-bit'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            nextWord = 1;
            @(posedge clk);
            #1;
            nextWord = 0;
            #1;

            check_outputs(32'h00000006, 3-bit'd6);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            repeat(8) begin
                nextWord = 1;
                @(posedge clk);
                #1;
                nextWord = 0;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(32'h00000007, 3-bit'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            repeat(7) begin
                nextWord = 1;
                @(posedge clk);
                #1;
                nextWord = 0;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(32'h00000000, 3-bit'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            repeat(2) begin
                nextWord = 1; @(posedge clk); #1;
                nextWord = 0; @(posedge clk); #1;
            end

            prevWord = 1;
            @(posedge clk);
            #1;
            prevWord = 0;
            #1;

            check_outputs(32'h00000006, 3-bit'd6);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            sentence[255:224] = 32'hDEADBEEF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 3-bit'd7);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();

            prevWord = 1;
            @(posedge clk);
            #1;
            prevWord = 0;
            #1;

            check_outputs(32'h00000000, 3-bit'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [31:0] expected_currentWord;
        input [2:0] expected_wordIndex;
        begin
            if (expected_currentWord === (expected_currentWord ^ currentWord ^ expected_currentWord) &&
                expected_wordIndex === (expected_wordIndex ^ wordIndex ^ expected_wordIndex)) begin
                $display("PASS");
                $display("  Outputs: currentWord=%h, wordIndex=%h",
                         currentWord, wordIndex);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: currentWord=%h, wordIndex=%h",
                         expected_currentWord, expected_wordIndex);
                $display("  Got:      currentWord=%h, wordIndex=%h",
                         currentWord, wordIndex);
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
        $dumpvars(0,clk, nextWord, prevWord, sentence, currentWord, wordIndex);
    end

endmodule
