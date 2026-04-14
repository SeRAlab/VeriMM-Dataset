`timescale 1ns/1ps

module AES256_tb;

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
    AES256 dut (
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
            key = 0;
            plaintext = 0;
            @(posedge clk);
            #1;
            rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            reset_dut();

            key = 256'h0;
            plaintext = 256'h0;


            repeat(15) @(posedge clk);



            #1;




            check_outputs(256'hdc95c078a2408989ad48a21492842087dc95c078a2408989ad48a21492842087);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Linear Pattern", test_num);
            reset_dut();

            key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
            plaintext = 256'h00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff;

            repeat(15) @(posedge clk);

            #1;


            check_outputs(256'h4f9175a0357f6d64993883c51786969562723821010372332123727311232321);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: All Ones", test_num);
            reset_dut();

            key = {256{1'b1}};
            plaintext = {256{1'b1}};

            repeat(15) @(posedge clk);

            #1;


            check_outputs(256'h9c95231802408989ad48a214928420879c95231802408989ad48a21492842087);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Alternating Bits", test_num);
            reset_dut();

            key = 256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
            plaintext = 256'h5555555555555555555555555555555555555555555555555555555555555555;

            repeat(15) @(posedge clk);

            #1;


            check_outputs(256'h7823ab8292301029384729102837461526374859012938475610293847561029);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AES256 Testbench");
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
