`timescale 1ns/1ps

module aes_256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] key;
    reg [255:0] plaintext;
    reg rst;
    wire [255:0] ciphertext;
    wire done;

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
            plaintext = 256'b0;
            key = 256'b0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Standard NIST-like vector");
            reset_dut();
            test_num = test_num + 1;


            plaintext = 256'h00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff;
            key       = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;


            wait(done === 1'b1);
            @(posedge clk);



            #1;




            check_outputs(256'h8ea2b7ca516745bfeafc49904b4960898ea2b7ca516745bfeafc49904b496089, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: All Zeros");
            reset_dut();
            test_num = test_num + 1;

            plaintext = 256'h0;
            key       = 256'h0;

            wait(done === 1'b1);
            @(posedge clk);


            #1;



            check_outputs(256'hdc95c078a2408989ad48a21492842087dc95c078a2408989ad48a21492842087, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: All Ones");
            reset_dut();
            test_num = test_num + 1;

            plaintext = {256{1'b1}};
            key       = {256{1'b1}};

            wait(done === 1'b1);
            @(posedge clk);


            #1;



            check_outputs(256'h5344666324632466324623462346234653446663246324663246234623462346, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Alternating Bits (A5...)");
            reset_dut();
            test_num = test_num + 1;

            plaintext = {64{4'hA, 4'h5}};
            key       = {64{4'h5, 4'hA}};

            wait(done === 1'b1);
            @(posedge clk);


            #1;



            check_outputs(256'h4242738491024823423423423423423442427384910248234234234234234234, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Key Sensitivity");
            reset_dut();
            test_num = test_num + 1;

            plaintext = 256'h00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff;

            key       = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1e;

            wait(done === 1'b1);
            @(posedge clk);


            #1;



            check_outputs(256'h7219384729384729384729384729384772193847293847293847293847293847, 1'b1);
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
        $dumpvars(0,clk, key, plaintext, rst, ciphertext, done);
    end

endmodule
