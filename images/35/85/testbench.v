`timescale 1ns/1ps

module simple_DES_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] key;
    reg [63:0] plaintext;
    reg reset;
    wire [63:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_DES dut (
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
            plaintext = 64'h0;
            key = 64'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            plaintext = 64'h0000000000000000;
            key       = 64'h0000000000000000;
            @(posedge clk);
            #2;


            #1;



            check_outputs(64'h8da2cc4d3f33d201);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            plaintext = 64'hFFFFFFFFFFFFFFFF;
            key       = 64'hFFFFFFFFFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h1391307f43168a1d);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            plaintext = 64'h0123456789ABCDEF;
            key       = 64'h133457799BBCDFF1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h86542617f694692e);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            plaintext = 64'h0123456789ABCDEF;
            key       = 64'h0000000000000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h9991206f4705051c);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            plaintext = 64'h5555555555555555;
            key       = 64'hAAAAAAAAAAAAAAAA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(64'h2f87a86991c6e611);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_DES Testbench");
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
        input [63:0] expected_ciphertext;
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
