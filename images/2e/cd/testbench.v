`timescale 1ns/1ps

module rsa_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] e;
    reg [15:0] n;
    reg [15:0] plaintext;
    reg rst;
    wire [15:0] ciphertext;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rsa_encrypt dut (
        .clk(clk),
        .e(e),
        .n(n),
        .plaintext(plaintext),
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
            rst = 1;
            e = 0;
            n = 0;
            plaintext = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("\nTest Case %0d: Simple small values (2^3 mod 11)", test_num);
            plaintext = 16'd2;
            e = 16'd3;
            n = 16'd11;


            @(posedge clk);
            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd8, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("\nTest Case %0d: Intermediate values (5^3 mod 13)", test_num);
            plaintext = 16'd5;
            e = 16'd3;
            n = 16'd13;

            @(posedge clk);
            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd8, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("\nTest Case %0d: Larger exponent (10^7 mod 33)", test_num);
            plaintext = 16'd10;
            e = 16'd7;
            n = 16'd33;

            @(posedge clk);
            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd10, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("\nTest Case %0d: Plaintext 0 (0^e mod n)", test_num);
            plaintext = 16'd0;
            e = 16'd5;
            n = 16'd13;

            @(posedge clk);
            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("\nTest Case %0d: Plaintext 1 (1^e mod n)", test_num);
            plaintext = 16'd1;
            e = 16'd17;
            n = 16'd3233;

            @(posedge clk);
            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("\nTest Case %0d: Exponent 1 (M^1 mod n)", test_num);
            plaintext = 16'd123;
            e = 16'd1;
            n = 16'd257;

            @(posedge clk);
            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd123, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("\nTest Case %0d: Verifying modular reduction (7^5 mod 119)", test_num);
            plaintext = 16'd7;
            e = 16'd5;
            n = 16'd119;

            @(posedge clk);
            wait(done);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd28, 1'b1);
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
        testcase007();
        
        
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
        input [15:0] expected_ciphertext;
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
        $dumpvars(0,clk, e, n, plaintext, rst, ciphertext, done);
    end

endmodule
