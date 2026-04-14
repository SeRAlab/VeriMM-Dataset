`timescale 1ns/1ps

module aes_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] key;
    reg [127:0] plaintext;
    reg rst;
    wire [127:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_encrypt dut (
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
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: All Zeros Input", test_num);
            reset_dut();

            key = 256'h0;
            plaintext = 128'h0;


            repeat(2) @(posedge clk);
            #1;







            #1;








            check_outputs(128'h36363636363636363636363636363636);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Standard Pattern", test_num);
            reset_dut();

            key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
            plaintext = 128'h00112233445566778899aabbccddeeff;

            repeat(2) @(posedge clk);
            #1;



            #1;




            check_outputs(128'hda2b7d377464049f50fa5d0f666f773b);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Alternating Bits", test_num);
            reset_dut();

            key = 256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
            plaintext = 128'h55555555555555555555555555555555;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(128'h36660606366606063666060636660606);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %04d: Maximum Bit Density", test_num);
            reset_dut();

            key = {256{1'b1}};
            plaintext = 128'h0;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(128'h26262626262626262626262626262626);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_encrypt Testbench");
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
        input [127:0] expected_ciphertext;
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
