`timescale 1ns/1ps

module RSA_Encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] e;
    reg [127:0] n;
    reg [127:0] plaintext;
    reg reset;
    wire [127:0] ciphertext;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RSA_Encrypt dut (
        .clk(clk),
        .e(e),
        .n(n),
        .plaintext(plaintext),
        .reset(reset),
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
            reset = 1;
            plaintext = 0;
            e = 0;
            n = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Plaintext = 1", test_num);
            plaintext = 128'h1;
            e = 128'h3;
            n = 128'h21;
            @(posedge clk);
            wait(done);
            #1;
            #1;

            check_outputs(128'h1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Plaintext = 0", test_num);
            plaintext = 128'h0;
            e = 128'h3;
            n = 128'h21;
            @(posedge clk);
            wait(done);
            #1;
            #1;

            check_outputs(128'h0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Small RSA (2^3 mod 33)", test_num);
            plaintext = 128'h2;
            e = 128'h3;
            n = 128'h21;
            @(posedge clk);
            wait(done);
            #1;
            #1;

            check_outputs(128'h8, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Moderate RSA (10^5 mod 91)", test_num);
            plaintext = 128'd10;
            e = 128'd5;
            n = 128'd91;
            @(posedge clk);
            wait(done);
            #1;
            #1;

            check_outputs(128'h52, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Standard RSA (65^17 mod 3233)", test_num);
            plaintext = 128'd65;
            e = 128'd17;
            n = 128'd3233;
            @(posedge clk);
            wait(done);
            #1;
            #1;

            check_outputs(128'hAE6, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Corner Case (C = n-1)", test_num);
            plaintext = 128'd12;
            e = 128'd3;
            n = 128'd247;
            @(posedge clk);
            wait(done);
            #1;
            #1;

            check_outputs(128'hF6, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RSA_Encrypt Testbench");
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
        $dumpvars(0,clk, e, n, plaintext, reset, ciphertext, done);
    end

endmodule
