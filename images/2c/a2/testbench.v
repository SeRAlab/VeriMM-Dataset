`timescale 1ns/1ps

module rsa_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] plaintext;
    reg rst;
    wire [15:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rsa_encrypt dut (
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
            plaintext = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            plaintext = 16'd2;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'd8);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            plaintext = 16'd4;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'd31);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            plaintext = 16'd10;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'd10);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            plaintext = 16'd1;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            plaintext = 16'd0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            plaintext = 16'd5;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'd26);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            plaintext = 16'd32;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'd32);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rsa_encrypt Testbench");
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
        input [15:0] expected_ciphertext;
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
