`timescale 1ns/1ps

module RSA_Encryption_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] e;
    reg [11:0] n;
    reg [7:0] plaintext;
    reg reset;
    wire [11:0] ciphertext;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RSA_Encryption dut (
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
        e = 0;
        n = 0;
        plaintext = 0;
        #20;
        reset = 0;
        @(posedge clk);
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 2^3 mod 11", test_num);
        reset_dut();
        plaintext = 8'd2;
        e = 12'd3;
        n = 12'd11;
        @(posedge done);
        #5;
        #1;

        check_outputs(12'd8, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 5^3 mod 13", test_num);
        reset_dut();
        plaintext = 8'd5;
        e = 12'd3;
        n = 12'd13;
        @(posedge done);
        #5;
        #1;

        check_outputs(12'd8, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 42^1 mod 100", test_num);
        reset_dut();
        plaintext = 8'd42;
        e = 12'd1;
        n = 12'd100;
        @(posedge done);
        #5;
        #1;

        check_outputs(12'd42, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 10^5 mod 21", test_num);
        reset_dut();
        plaintext = 8'd10;
        e = 12'd5;
        n = 12'd21;
        @(posedge done);
        #5;
        #1;

        check_outputs(12'd19, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 255^2 mod 500", test_num);
        reset_dut();
        plaintext = 8'd255;
        e = 12'd2;
        n = 12'd500;
        @(posedge done);
        #5;
        #1;

        check_outputs(12'd25, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 0^7 mod 50", test_num);
        reset_dut();
        plaintext = 8'd0;
        e = 12'd7;
        n = 12'd50;
        @(posedge done);
        #5;
        #1;

        check_outputs(12'd0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 1^123 mod 100", test_num);
        reset_dut();
        plaintext = 8'd1;
        e = 12'd123;
        n = 12'd100;
        @(posedge done);
        #5;
        #1;

        check_outputs(12'd1, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 11^3 mod 1000", test_num);
        reset_dut();
        plaintext = 8'd11;
        e = 12'd3;
        n = 12'd1000;
        @(posedge done);
        #5;
        #1;

        check_outputs(12'd331, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RSA_Encryption Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [11:0] expected_ciphertext;
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
