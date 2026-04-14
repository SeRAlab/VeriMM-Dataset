`timescale 1ns/1ps

module aes256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] key;
    reg [255:0] plaintext;
    reg rst;
    reg start;
    wire [255:0] ciphertext;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes256 dut (
        .clk(clk),
        .key(key),
        .plaintext(plaintext),
        .rst(rst),
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
            rst = 1;
            start = 0;
            key = 0;
            plaintext = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            key = 256'h0;
            plaintext = 256'h0;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done == 1);




            #1;





            check_outputs(256'hdc95c078a2408989ad48a21492842087dc95c078a2408989ad48a21492842087, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            key = {256{1'b1}};
            plaintext = {256{1'b1}};

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);


            #1;



            check_outputs(256'h500445a4944d6614749f992383845a70500445a4944d6614749f992383845a70, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
            plaintext = 256'h00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);


            #1;



            check_outputs(256'h8ea2b7ca516745bfeafc49904b4960898ea2b7ca516745bfeafc49904b496089, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            key = 256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
            plaintext = 256'h5555555555555555555555555555555555555555555555555555555555555555;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1);


            #1;



            check_outputs(256'h9c9b91752b047539097940263f3885d99c9b91752b047539097940263f3885d9, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes256 Testbench");
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
        $dumpvars(0,clk, key, plaintext, rst, start, ciphertext, done);
    end

endmodule
