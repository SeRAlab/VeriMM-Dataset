`timescale 1ns/1ps

module aes_256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] key;
    reg [255:0] plaintext;
    reg reset;
    wire [255:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_256 dut (
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
            key = 0;
            plaintext = 0;
            @(posedge clk);
            #1 reset = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Plaintext and Key", test_num);
            reset_dut();
            plaintext = 256'h0;
            key = 256'h0;


            repeat(12) @(posedge clk);


            #1;



            check_outputs(256'h6207604646738914093959451458804646738914093959451458801234567890);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Plaintext and Key", test_num);
            reset_dut();
            plaintext = {8{32'hFFFFFFFF}};
            key = {8{32'hFFFFFFFF}};

            repeat(12) @(posedge clk);


            #1;



            check_outputs(256'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Specific Data/Key Mix", test_num);
            reset_dut();
            plaintext = 256'h00112233445566778899AABBCCDDEEFF00112233445566778899AABBCCDDEEFF;
            key       = 256'h000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F;

            repeat(12) @(posedge clk);


            #1;



            check_outputs(256'h8EA2B7CA516745BFEAFE7AD233A9D6A316A3D123456789ABCDEF0123456789AB);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (55/AA)", test_num);
            reset_dut();
            plaintext = {16{16'h5555}};
            key       = {16{16'hAAAA}};

            repeat(12) @(posedge clk);


            #1;



            check_outputs(256'h7B12456A8293C4E51029384756A7B8C9D0E1F2A3B4C5D6E7F8A9B0C1D2E3F4A5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_256 Testbench");
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
        $dumpvars(0,clk, key, plaintext, reset, ciphertext);
    end

endmodule
