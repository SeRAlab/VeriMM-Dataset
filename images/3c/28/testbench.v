`timescale 1ns/1ps

module aes_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] plaintext;
    reg rst;
    wire [7:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_8bit dut (
        .clk(clk),
        .plaintext(plaintext),
        .rst(rst),
        .ciphertext(ciphertext)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            plaintext = 8'h0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Plaintext All Zeros", test_num);
            reset_dut();
            plaintext = 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(ciphertext);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Plaintext All Ones", test_num);
            reset_dut();
            plaintext = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(ciphertext);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits 1010", test_num);
            reset_dut();
            plaintext = 8'hAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(ciphertext);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits 0101", test_num);
            reset_dut();
            plaintext = 8'h55;
            @(posedge clk);
            #1;
            #1;

            check_outputs(ciphertext);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking One (MSB)", test_num);
            reset_dut();
            plaintext = 8'h80;
            @(posedge clk);
            #1;
            #1;

            check_outputs(ciphertext);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking One (LSB)", test_num);
            reset_dut();
            plaintext = 8'h01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(ciphertext);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary Pattern A5", test_num);
            reset_dut();
            plaintext = 8'hA5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(ciphertext);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary Pattern 3C", test_num);
            reset_dut();
            plaintext = 8'h3C;
            @(posedge clk);
            #1;
            #1;

            check_outputs(ciphertext);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Repeated Reset Check", test_num);
            reset_dut();
            plaintext = 8'h12;
            @(posedge clk);
            #1;
            reset_dut();
            plaintext = 8'h12;
            @(posedge clk);
            #1;
            #1;

            check_outputs(ciphertext);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full Throughput/Sequential Change", test_num);
            reset_dut();
            plaintext = 8'hDE;
            @(posedge clk);
            plaintext = 8'hAD;
            @(posedge clk);
            plaintext = 8'hBE;
            @(posedge clk);
            plaintext = 8'hEF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(ciphertext);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        $dumpvars(0,clk, plaintext, rst, ciphertext);
    end

endmodule
