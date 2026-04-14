`timescale 1ns/1ps

module aes_256_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] key;
    reg [127:0] plaintext;
    reg start;
    wire [127:0] ciphertext;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_256_encrypt dut (
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
            key = 0;
            plaintext = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros Vector", test_num);
            reset_dut();

            key = 256'h0000000000000000000000000000000000000000000000000000000000000000;
            plaintext = 128'h00000000000000000000000000000000;

            start = 1;
            @(posedge clk);
            start = 0;


            wait(done);
            @(posedge clk);


            #1;



            check_outputs(128'hdc95c078a2408989ad48a21492842087, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: FIPS-197 Sequential Vector", test_num);
            reset_dut();

            key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
            plaintext = 128'h00112233445566778899aabbccddeeff;

            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(128'h8ea2b7ca516745bfeafc49904b496089, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: NIST SP 800-38A Vector", test_num);
            reset_dut();

            key = 256'h603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4;
            plaintext = 128'h6bc1bee22e409f96e93d7e117393172a;

            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(128'hf3eea821fb0f951f44e3dca061164c67, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All FFs Vector", test_num);
            reset_dut();

            key = 256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
            plaintext = 128'hffffffffffffffffffffffffffffffff;

            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);


            #1;



            check_outputs(128'h52a167733596791e813a34a8e999c049, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Specific NIST KAT", test_num);
            reset_dut();

            key = 256'h0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef;
            plaintext = 128'h0123456789abcdef0123456789abcdef;

            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(128'hbe157121051522070002191953282a5c, 1'b1);
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
        input [127:0] expected_ciphertext;
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
