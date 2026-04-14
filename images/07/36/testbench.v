`timescale 1ns/1ps

module aes_256_enc_tb;

    // Testbench signals (sequential circuit)
    reg [255:0] key;
    reg [255:0] plaintext;
    reg start;
    wire [255:0] ciphertext;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_256_enc dut (
        .key(key),
        .plaintext(plaintext),
        .start(start),
        .ciphertext(ciphertext),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        start = 0;
        forever #5 start = ~start;
    end

        task reset_dut;

        begin
            rst_n = 0;
            start = 0;
            key = 0;
            plaintext = 0;
            repeat(2) @(posedge clk);
            rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %03d: All Zeros", test_num);
            reset_dut();

            key = 256'h0000000000000000000000000000000000000000000000000000000000000000;
            plaintext = 256'h0000000000000000000000000000000000000000000000000000000000000000;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done);
            @(posedge clk);


            #1;



            check_outputs(256'hc14d93ed7fd34947936171f114c0a1843b9d62d294025a1f73600572674e743d, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %03d: Incremental Pattern", test_num);
            reset_dut();

            key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
            plaintext = 256'h00112233445566778899aabbccddeefff0f1f2f3f4f5f6f7f8f9fafbfcfdfeff;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);


            #1;



            check_outputs(256'h8ea2b7ca516745bfeafc49904b496089b325d5d39e22f002d9210673024843b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %03d: All Ones", test_num);
            reset_dut();

            key = {256{1'b1}};
            plaintext = {256{1'b1}};

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);


            #1;



            check_outputs(256'h534b8c9d2c12574996929a00778c8e889311e9f906411f12d508492219430c6f, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_256_enc Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        
        
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
        $dumpvars(0,key, plaintext, start, ciphertext, done);
    end

endmodule
