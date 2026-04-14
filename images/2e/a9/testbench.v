`timescale 1ns/1ps

module aes_256_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] key;
    reg [255:0] plaintext;
    reg rst_n;
    reg start;
    wire [255:0] ciphertext;
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
        .rst_n(rst_n),
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
        rst_n = 0;
        start = 0;
        key = 0;
        plaintext = 0;
        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: NIST-based Vector (Standard Keys)", test_num);
        reset_dut();


        key       = 256'h603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4;
        plaintext = 256'h6bc1bee22e409f96e93d7e117393172aae2d8a571e03ac9c9eb76fac45af8e51;

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;


        wait(done == 1'b1);
        @(posedge clk);



        #1;




        check_outputs(256'hf3eed1bdb5d2a03c0619803062f4c0271fdc11e7256923c89694c965e6df3146, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All Zeros Input", test_num);
        reset_dut();

        key       = 256'h0000000000000000000000000000000000000000000000000000000000000000;
        plaintext = 256'h0000000000000000000000000000000000000000000000000000000000000000;

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done == 1'b1);
        @(posedge clk);


        #1;



        check_outputs(256'hdc95c078a2408989ad48a214928420875320140232b698012b67891230192013, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All Ones Input", test_num);
        reset_dut();

        key       = {256{1'b1}};
        plaintext = {256{1'b1}};

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done == 1'b1);
        @(posedge clk);


        #1;



        check_outputs(256'h72c0c16937f22e8003f56d95368a5c378e9b671d43a2909c9b67a01d33401201, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Pattern Input", test_num);
        reset_dut();

        key       = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
        plaintext = 256'h0123456789abcdeffedcba98765432100123456789abcdeffedcba9876543210;

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        wait(done == 1'b1);
        @(posedge clk);

        #1;


        check_outputs(256'h62768560155694f2777f985a975612344a1b0c2d3e4f5a6b7c8d9e0f1a2b3c4d, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset during operation", test_num);
        reset_dut();

        key       = 256'hFFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000;
        plaintext = 256'hAAAA5555AAAA5555AAAA5555AAAA5555AAAA5555AAAA5555AAAA5555AAAA5555;

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;


        repeat(5) @(posedge clk);


        rst_n = 0;
        repeat(2) @(posedge clk);
        rst_n = 1;
        @(posedge clk);


        if (done === 1'b0) begin
            $display("PASS: Reset cleared 'done' signal successfully.");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: 'done' signal stayed high or unknown after reset.");
            fail_count = fail_count + 1;
        end
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
        input [255:0] expected_ciphertext;
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
        $dumpvars(0,clk, key, plaintext, rst_n, start, ciphertext, done);
    end

endmodule
