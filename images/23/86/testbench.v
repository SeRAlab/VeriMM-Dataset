`timescale 1ns/1ps

module rsa_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] e;
    reg [127:0] n;
    reg [127:0] plaintext;
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
            plaintext = 0;
            e = 0;
            n = 0;
            repeat(5) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Small Values (M=3, e=7, n=33)", test_num);
            plaintext = 128'd3;
            e = 128'd7;
            n = 128'd33;

            @(posedge clk);
            wait(done);
            repeat(1) @(posedge clk);
            #1;

            check_outputs(128'd9, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Identity Exponent (e=1)", test_num);
            plaintext = 128'hDEADBEEFCAFEBABE1234567887654321;
            e = 128'd1;
            n = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

            @(posedge clk);
            wait(done);
            repeat(1) @(posedge clk);
            #1;

            check_outputs(128'hDEADBEEFCAFEBABE1234567887654321, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Plaintext Zero", test_num);
            plaintext = 128'd0;
            e = 128'h10001;
            n = 128'd3233;

            @(posedge clk);
            wait(done);
            repeat(1) @(posedge clk);
            #1;

            check_outputs(128'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Plaintext One", test_num);
            plaintext = 128'd1;
            e = 128'h10001;
            n = 128'd3233;

            @(posedge clk);
            wait(done);
            repeat(1) @(posedge clk);
            #1;

            check_outputs(128'd1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTest Case %0d: Textbook RSA (M=123, e=17, n=3233)", test_num);
            plaintext = 128'd123;
            e = 128'd17;
            n = 128'd3233;

            @(posedge clk);
            wait(done);
            repeat(1) @(posedge clk);
            #1;

            check_outputs(128'd855, 1'b1);
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
        $dumpvars(0,clk, e, n, plaintext, rst, ciphertext, done);
    end

endmodule
