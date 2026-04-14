`timescale 1ns/1ps

module rsa_encryption_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] modulus;
    reg [15:0] plaintext;
    reg [15:0] public_key;
    reg rst;
    wire [15:0] ciphertext;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rsa_encryption dut (
        .clk(clk),
        .modulus(modulus),
        .plaintext(plaintext),
        .public_key(public_key),
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
        public_key = 0;
        modulus = 0;
        #20;
        rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Running Testcase %0d: Small basic calculation (3^3 mod 33)", test_num);
        plaintext = 16'd3;
        public_key = 16'd3;
        modulus = 16'd33;
        wait(done == 0);
        wait(done == 1);
        #2;
        #1;

        check_outputs(16'd27, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Running Testcase %0d: Modular exponentiation (7^5 mod 119)", test_num);
        plaintext = 16'd7;
        public_key = 16'd5;
        modulus = 16'd119;
        wait(done == 1);
        #2;
        #1;

        check_outputs(16'd28, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Running Testcase %0d: Zero message (0^17 mod 391)", test_num);
        plaintext = 16'd0;
        public_key = 16'd17;
        modulus = 16'd391;
        wait(done == 1);
        #2;
        #1;

        check_outputs(16'd0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Running Testcase %0d: Identity message (1^65535 mod 257)", test_num);
        plaintext = 16'd1;
        public_key = 16'hFFFF;
        modulus = 16'd257;
        wait(done == 1);
        #2;
        #1;

        check_outputs(16'd1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Running Testcase %0d: Exponent is 1 (42^1 mod 100)", test_num);
        plaintext = 16'd42;
        public_key = 16'd1;
        modulus = 16'd100;
        wait(done == 1);
        #2;
        #1;

        check_outputs(16'd42, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Running Testcase %0d: Moderate values (10^3 mod 187)", test_num);
        plaintext = 16'd10;
        public_key = 16'd3;
        modulus = 16'd187;
        wait(done == 1);
        #2;
        #1;

        check_outputs(16'd65, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Running Testcase %0d: Power of 2 (2^10 mod 1000)", test_num);
        plaintext = 16'd2;
        public_key = 16'd10;
        modulus = 16'd1000;
        wait(done == 1);
        #2;
        #1;

        check_outputs(16'd24, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rsa_encryption Testbench");
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
        $dumpvars(0,clk, modulus, plaintext, public_key, rst, ciphertext, done);
    end

endmodule
