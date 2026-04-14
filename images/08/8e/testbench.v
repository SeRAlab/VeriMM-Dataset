`timescale 1ns/1ps

module rsa_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] plaintext;
    reg [127:0] public_key_e;
    reg [127:0] public_key_n;
    reg rst;
    wire [127:0] ciphertext;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rsa_encrypt dut (
        .clk(clk),
        .plaintext(plaintext),
        .public_key_e(public_key_e),
        .public_key_n(public_key_n),
        .rst(rst),
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
            $display("\nResetting DUT...");
            rst = 1;
            plaintext = 0;
            public_key_e = 0;
            public_key_n = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Small value exponentiation (5^3 mod 13)", test_num);

            plaintext = 128'd5;
            public_key_e = 128'd3;
            public_key_n = 128'd13;


            wait(done === 1);
            #10;

            #1;


            check_outputs(128'd8, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Identity exponent (e=1)", test_num);

            plaintext = 128'd12345;
            public_key_e = 128'd1;
            public_key_n = 128'd65537;

            wait(done === 1);
            #10;

            #1;


            check_outputs(128'd12345, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: RSA with n=33, e=7, P=10", test_num);

            plaintext = 128'd10;
            public_key_e = 128'd7;
            public_key_n = 128'd33;

            wait(done === 1);
            #10;

            #1;


            check_outputs(128'd10, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: 2^11 mod 23", test_num);

            plaintext = 128'd2;
            public_key_e = 128'd11;
            public_key_n = 128'd23;

            wait(done === 1);
            #10;

            #1;


            check_outputs(128'd1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Power of 2 (2^16 mod 65537)", test_num);

            plaintext = 128'd2;
            public_key_e = 128'd16;
            public_key_n = 128'd65537;

            wait(done === 1);
            #10;

            #1;


            check_outputs(128'hFFFF, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: 7^5 mod 1000", test_num);

            plaintext = 128'd7;
            public_key_e = 128'd5;
            public_key_n = 128'd1000;

            wait(done === 1);
            #10;

            #1;


            check_outputs(128'd807, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rsa_encrypt Testbench");
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
        $dumpvars(0,clk, plaintext, public_key_e, public_key_n, rst, ciphertext, done);
    end

endmodule
