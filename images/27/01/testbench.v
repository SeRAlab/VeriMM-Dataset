`timescale 1ns/1ps

module aes_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] key;
    reg [7:0] plaintext;
    reg reset;
    wire [7:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_8bit dut (
        .clk(clk),
        .key(key),
        .plaintext(plaintext),
        .reset(reset),
        .ciphertext(ciphertext)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            plaintext = 8'h00;
            key = 8'h00;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: All Zeros", test_num);
            reset_dut();
            plaintext = 8'h00;
            key = 8'h00;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(8'h63);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: All Ones Plaintext, Zero Key", test_num);
            reset_dut();
            plaintext = 8'hFF;
            key = 8'h00;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(8'h16);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Zero Plaintext, All Ones Key", test_num);
            reset_dut();
            plaintext = 8'h00;
            key = 8'hFF;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(8'hE9);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Alternating Bit Patterns", test_num);
            reset_dut();
            plaintext = 8'hAA;
            key = 8'h55;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(8'hE9);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Walking Ones", test_num);
            reset_dut();
            plaintext = 8'h01;
            key = 8'h02;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(8'h79);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: High Entropy Pattern", test_num);
            reset_dut();
            plaintext = 8'h3C;
            key = 8'hA5;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(8'h4B);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Maximum Value Flip", test_num);
            reset_dut();
            plaintext = 8'hFF;
            key = 8'hFF;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(8'h9C);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_8bit Testbench");
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
        input [7:0] expected_ciphertext;
        begin
            if (expected_ciphertext === (expected_ciphertext ^ ciphertext ^ expected_ciphertext)) begin
                $display("PASS");
                $display("  Outputs: ciphertext=%h",
                         ciphertext);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ciphertext=%h",
                         expected_ciphertext);
                $display("  Got:      ciphertext=%h",
                         ciphertext);
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
        $dumpvars(0,clk, key, plaintext, reset, ciphertext);
    end

endmodule
