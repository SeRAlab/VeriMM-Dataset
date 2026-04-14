`timescale 1ns/1ps

module aes_256_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] key;
    reg [255:0] plaintext;
    reg reset;
    reg valid;
    wire [255:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_256_encrypt dut (
        .clk(clk),
        .key(key),
        .plaintext(plaintext),
        .reset(reset),
        .valid(valid),
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
            valid = 0;
            plaintext = 0;
            key = 0;
            repeat(2) @(posedge clk);
            reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros Plaintext and Key", test_num);
            reset_dut();
            @(posedge clk);
            plaintext = 256'h0;
            key       = 256'h0;
            valid     = 1;
            @(posedge clk);
            valid     = 0;

            repeat(20) @(posedge clk);

            #1;


            check_outputs(256'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Ones Plaintext and Key", test_num);
            reset_dut();
            @(posedge clk);
            plaintext = {8{32'hFFFFFFFF}};
            key       = {8{32'hFFFFFFFF}};
            valid     = 1;
            @(posedge clk);
            valid     = 0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(256'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Checkerboard Pattern", test_num);
            reset_dut();
            @(posedge clk);
            plaintext = 256'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            key       = 256'h5555555555555555555555555555555555555555555555555555555555555555;
            valid     = 1;
            @(posedge clk);
            valid     = 0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(256'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mixed Hex Pattern", test_num);
            reset_dut();
            @(posedge clk);
            plaintext = 256'h00112233445566778899AABBCCDDEEFF00112233445566778899AABBCCDDEEFF;
            key       = 256'h000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F;
            valid     = 1;
            @(posedge clk);
            valid     = 0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(256'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Key Change Sensitivity", test_num);
            reset_dut();
            @(posedge clk);
            plaintext = 256'hDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEF;
            key       = 256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
            valid     = 1;
            @(posedge clk);
            valid     = 0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(256'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_256_encrypt Testbench");
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
        input [255:0] expected_ciphertext;
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
        $dumpvars(0,clk, key, plaintext, reset, valid, ciphertext);
    end

endmodule
