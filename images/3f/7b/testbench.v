`timescale 1ns/1ps

module aes_128_encryption_tb;

    // Testbench signals (sequential circuit)
    reg [127:0] key;
    reg [127:0] plaintext;
    reg start;
    wire [127:0] ciphertext;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_128_encryption dut (
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
            plaintext <= 128'b0;
            key <= 128'b0;

            repeat (5) @(posedge start);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %03d: NIST FIPS 197 Appendix B", test_num);
            reset_dut();


            plaintext = 128'h00112233445566778899aabbccddeeff;
            key       = 128'h000102030405060708090a0b0c0d0e0f;


            wait(done == 1'b1);
            @(posedge start);


            #1;



            check_outputs(128'h69c4e0d86a7b0430d8cdb78070b4c55a, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %03d: All Zeros", test_num);
            reset_dut();

            plaintext = 128'h00000000000000000000000000000000;
            key       = 128'h00000000000000000000000000000000;

            wait(done == 1'b1);
            @(posedge start);


            #1;



            check_outputs(128'h66e94bd4ef8a2c3b884cfa59ca342b2e, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %03d: NIST SP 800-38A Vector 1", test_num);
            reset_dut();

            plaintext = 128'h6bc1bee22e409f96e93d7e117393172a;
            key       = 128'h2b7e151628aed2a6abf7158809cf4f3c;

            wait(done == 1'b1);
            @(posedge start);


            #1;



            check_outputs(128'h3ad77bb40d7a3660a89ecaf32466ef97, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %03d: NIST SP 800-38A Vector 2", test_num);
            reset_dut();

            plaintext = 128'hae2d8a571e03ac9c9eb76fac45af8e51;
            key       = 128'h2b7e151628aed2a6abf7158809cf4f3c;

            wait(done == 1'b1);
            @(posedge start);


            #1;



            check_outputs(128'hf5d3d58503b9699de785895a96fdbaaf, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %03d: High-density input", test_num);
            reset_dut();

            plaintext = 128'hffffffffffffffffffffffffffffffff;
            key       = 128'h00000000000000000000000000000000;

            wait(done == 1'b1);
            @(posedge start);


            #1;



            check_outputs(128'ha1f6258c877d5fcd8964484538bfc92c, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_128_encryption Testbench");
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
        $dumpvars(0,key, plaintext, start, ciphertext, done);
    end

endmodule
