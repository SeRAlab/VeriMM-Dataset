`timescale 1ns/1ps

module aes_256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] key;
    reg [255:0] plaintext;
    reg rst;
    wire [255:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_256 dut (
        .clk(clk),
        .key(key),
        .plaintext(plaintext),
        .rst(rst),
        .ciphertext(ciphertext)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        plaintext = 256'b0;
        key = 256'b0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Running Testcase %0d: All Zeros Input", test_num);
        plaintext = 256'h0000000000000000000000000000000000000000000000000000000000000000;
        key       = 256'h0000000000000000000000000000000000000000000000000000000000000000;

        repeat(20) @(posedge clk);
        #1;

        check_outputs(256'hdc95c078a2408989ad48a21492842087530293d480a00940337c72f102559e3a);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Running Testcase %0d: All Ones Input", test_num);
        plaintext = 256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        key       = 256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        repeat(20) @(posedge clk);

        #1;


        check_outputs(256'h59441295b92209d17d69288e731422d641d408f62337d9760920b3367b607629);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Running Testcase %0d: Incremental Pattern", test_num);
        plaintext = 256'h0123456789abcdeffedcba98765432100123456789abcdeffedcba9876543210;
        key       = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
        repeat(20) @(posedge clk);
        #1;

        check_outputs(256'h98801d9006c8343e03d38e2d787038e417537554972183578712398510821034);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Running Testcase %0d: Checkerboard Pattern", test_num);
        plaintext = 256'ha5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5;
        key       = 256'h5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a5a;
        repeat(20) @(posedge clk);
        #1;

        check_outputs(256'h8782356102143498305712039471023475012384710239487102347102394871);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_256 Testbench");
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
        input [255:0] expected_ciphertext;
        begin
            if (expected_ciphertext === (expected_ciphertext ^ ciphertext ^ expected_ciphertext)) begin
                $display("PASS");
                $display("  Outputs: ciphertext=%h",
                         ciphertext);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ciphertext=%h",
                         expected_ciphertext);
                $display("  Got:      ciphertext=%h",
                         ciphertext);
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
        $dumpvars(0,clk, key, plaintext, rst, ciphertext);
    end

endmodule
