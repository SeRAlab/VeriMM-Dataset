`timescale 1ns/1ps

module rsa_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] p;
    reg [7:0] plaintext;
    reg [7:0] q;
    reg reset;
    wire [15:0] ciphertext;
    wire [15:0] e;
    wire [15:0] n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rsa_encrypt dut (
        .clk(clk),
        .p(p),
        .plaintext(plaintext),
        .q(q),
        .reset(reset),
        .ciphertext(ciphertext),
        .e(e),
        .n(n)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            p = 0;
            q = 0;
            plaintext = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: p=11, q=13, msg=7");
            reset_dut();
            test_num = 1;
            p = 8'd11;
            q = 8'd13;
            plaintext = 8'd7;


            repeat(100) @(posedge clk);

            #1;


            check_outputs(16'd50, 16'd65537, 16'd143);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: p=17, q=19, msg=10");
            reset_dut();
            test_num = 2;
            p = 8'd17;
            q = 8'd19;
            plaintext = 8'd10;

            repeat(100) @(posedge clk);

            #1;


            check_outputs(16'd78, 16'd65537, 16'd323);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: p=5, q=11, msg=3");
            reset_dut();
            test_num = 3;
            p = 8'd5;
            q = 8'd11;
            plaintext = 8'd3;

            repeat(100) @(posedge clk);

            #1;


            check_outputs(16'd53, 16'd65537, 16'd55);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: p=23, q=7, msg=12");
            reset_dut();
            test_num = 4;
            p = 8'd23;
            q = 8'd7;
            plaintext = 8'd12;

            repeat(100) @(posedge clk);

            #1;


            check_outputs(16'd12, 16'd65537, 16'd161);
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
        input [15:0] expected_e;
        input [15:0] expected_n;
        begin
            if (expected_ciphertext === (expected_ciphertext ^ ciphertext ^ expected_ciphertext) &&
                expected_e === (expected_e ^ e ^ expected_e) &&
                expected_n === (expected_n ^ n ^ expected_n)) begin
                $display("PASS");
                $display("  Outputs: ciphertext=%h, e=%h, n=%h",
                         ciphertext, e, n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ciphertext=%h, e=%h, n=%h",
                         expected_ciphertext, expected_e, expected_n);
                $display("  Got:      ciphertext=%h, e=%h, n=%h",
                         ciphertext, e, n);
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
        $dumpvars(0,clk, p, plaintext, q, reset, ciphertext, e, n);
    end

endmodule
