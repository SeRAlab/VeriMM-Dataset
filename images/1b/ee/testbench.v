`timescale 1ns/1ps

module chacha20_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] key;
    reg [31:0] plaintext;
    reg rst;
    wire [31:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20 dut (
        .clk(clk),
        .key(key),
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
            key = 32'h0;
            plaintext = 32'h0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            key = 32'h00000000;
            plaintext = 32'h00000000;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(ciphertext);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            key = 32'hFFFFFFFF;
            plaintext = 32'hFFFFFFFF;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(ciphertext);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            key = 32'hAAAAAAAA;
            plaintext = 32'h55555555;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(ciphertext);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            key = 32'h12345678;
            plaintext = 32'h87654321;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(ciphertext);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            key = 32'h00000001;
            plaintext = 32'h80000000;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(ciphertext);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            key = 32'hDEADBEEF;
            plaintext = 32'hCAFEBABE;
            repeat(2) @(posedge clk);

            rst = 1;
            @(posedge clk);
            rst = 0;
            repeat(10) @(posedge clk);
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
        $display("chacha20 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [31:0] expected_ciphertext;
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
        $dumpvars(0,clk, key, plaintext, rst, ciphertext);
    end

endmodule
