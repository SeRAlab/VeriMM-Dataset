`timescale 1ns/1ps

module simple_des_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] key;
    reg [63:0] plaintext;
    reg start;
    wire [63:0] ciphertext;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_des dut (
        .clk(clk),
        .key(key),
        .plaintext(plaintext),
        .start(start),
        .ciphertext(ciphertext),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        start = 0;
        key = 64'h0;
        plaintext = 64'h0;
        @(posedge clk);
        #1;
    end
        endtask
    task run_encryption;

        input [63:0] in_plaintext;
        input [63:0] in_key;
    begin
        plaintext = in_plaintext;
        key = in_key;
        start = 1;
        @(posedge clk);
        #1;
        start = 0;

        wait(done == 1'b1);
        @(posedge clk);
        #1;
    end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        reset_dut();
        run_encryption(64'h0000000000000000, 64'h0000000000000000);
        #1;

        check_outputs(64'h8CA64DE9C1B123A7, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones", test_num);
        reset_dut();
        run_encryption(64'hFFFFFFFFFFFFFFFF, 64'hFFFFFFFFFFFFFFFF);
        #1;

        check_outputs(64'h7359B2163E4EDC58, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Standard NIST Vector", test_num);
        reset_dut();
        run_encryption(64'h0123456789ABCDEF, 64'h133457799BBCDFF1);
        #1;

        check_outputs(64'h85E813540F0AB405, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Pattern", test_num);
        reset_dut();
        run_encryption(64'h5555555555555555, 64'hAAAAAAAAAAAAAAAA);
        #1;

        check_outputs(64'h246E9DB9C550381A, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_des Testbench");
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
        input [63:0] expected_ciphertext;
        input expected_done;
        begin
            if (expected_ciphertext === (expected_ciphertext ^ ciphertext ^ expected_ciphertext) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: ciphertext=%h, done=%b",
                         ciphertext, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ciphertext=%h, done=%b",
                         expected_ciphertext, expected_done);
                $display("  Got:      ciphertext=%h, done=%b",
                         ciphertext, done);
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
        $dumpvars(0,clk, key, plaintext, start, ciphertext, done);
    end

endmodule
