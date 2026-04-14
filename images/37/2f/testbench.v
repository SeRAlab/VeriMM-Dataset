`timescale 1ns/1ps

module AES256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] key;
    reg [255:0] plaintext;
    reg rst;
    wire [255:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AES256 dut (
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
            key = 0;
            plaintext = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros", test_num);
            reset_dut();
            key = 256'h0;
            plaintext = 256'h0;


            #500;



            #1;




            check_outputs(256'hDC95C078A2408989AD48A21492842087DC95C078A2408989AD48A21492842087);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Ones", test_num);
            reset_dut();
            key = {256{1'b1}};
            plaintext = {256{1'b1}};

            #500;

            #1;


            check_outputs(256'h7201389868739185032810349817230498172039487120394871029348710239);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Incremental Pattern", test_num);
            reset_dut();
            key       = 256'h000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F;
            plaintext = 256'h00112233445566778899AABBCCDDEEFF00112233445566778899AABBCCDDEEFF;

            #500;

            #1;


            check_outputs(256'h8EA2B7CA516745BFEAFC49904B4960898EA2B7CA516745BFEAFC49904B496089);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating Bit Patterns", test_num);
            reset_dut();
            key       = {128{2'b01}};
            plaintext = {128{2'b10}};

            #500;

            #1;


            check_outputs(256'h9A4D1C3B2E5F0A1B2C3D4E5F6A7B8C9D9A4D1C3B2E5F0A1B2C3D4E5F6A7B8C9D);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Specific Hex Pattern", test_num);
            reset_dut();
            key       = 256'h603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4;
            plaintext = 256'hf58c4c04d6e5f147b93c830248472530f58c4c04d6e5f147b93c830248472530;

            #500;


            #1;



            check_outputs(256'h2521941F48466100E341A29D6E5D74A12521941F48466100E341A29D6E5D74A1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AES256 Testbench");
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
        $dumpvars(0,clk, key, plaintext, rst, ciphertext);
    end

endmodule
