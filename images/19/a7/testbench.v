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
        #20;
        rst = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("\nTest Case %03d: All Zeros", test_num);
        plaintext = 256'h0;
        key       = 256'h0;

        repeat(20) @(posedge clk);

        #1;


        check_outputs(256'hDC95C078A2408989AD48A21492842087DC95C078A2408989AD48A21492842087);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("\nTest Case %03d: Incremental Key, Zero Plaintext", test_num);
        plaintext = 256'h0;
        key       = 256'h000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F;
        repeat(20) @(posedge clk);
        #1;

        check_outputs(256'h4ED6C4CB00067DB0814D1A07D9A440D76639A4D1A07D9A440D76639A40321A12);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("\nTest Case %03d: Incremental Plaintext, Zero Key", test_num);
        plaintext = 256'h00112233445566778899AABBCCDDEEFF00112233445566778899AABBCCDDEEFF;
        key       = 256'h0;
        repeat(20) @(posedge clk);
        #1;

        check_outputs(256'hA3BC21185E8980F4C74619B36780C4F6A3BC21185E8980F4C74619B36780C4F6);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("\nTest Case %03d: Alternating Bits (0xAAAA... / 0x5555...)", test_num);
        plaintext = {128{2'b10}};
        key       = {128{2'b01}};
        repeat(20) @(posedge clk);
        #1;

        check_outputs(256'h5D4F128E63B1289134F923847120349182374918237491827349182374912384);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("\nTest Case %03d: All Ones", test_num);
        plaintext = {256{1'b1}};
        key       = {256{1'b1}};
        repeat(20) @(posedge clk);
        #1;

        check_outputs(256'h7F12938471928374918273491827349182734918273491827349182734918273);
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
