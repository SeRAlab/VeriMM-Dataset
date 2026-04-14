`timescale 1ns/1ps

module aes_256_tb;

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
    aes_256 dut (
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
            $display("\nResetting DUT...");
            rst = 1;
            start = 0;
            plaintext = 256'b0;
            key = 256'b0;
            repeat (5) @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All-Zero Plaintext and Key", test_num);
            reset_dut();


            plaintext = 256'h0;
            key       = 256'h0;


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            while (!done) @(posedge clk);




            #1;





            check_outputs(256'hdc95c078a2408989ad48a21492842087dc95c078a2408989ad48a21492842087, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Incremental Data and Key", test_num);
            reset_dut();


            plaintext = 256'h00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff;
            key       = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            while (!done) @(posedge clk);


            #1;



            check_outputs(256'h8ea2b7ca516745bfeafc49904b4960898ea2b7ca516745bfeafc49904b496089, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating Bit Pattern", test_num);
            reset_dut();

            plaintext = 256'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            key       = 256'h5555555555555555555555555555555555555555555555555555555555555555;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            while (!done) @(posedge clk);



            #1;




            check_outputs(ciphertext, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Back-to-Back Start Check", test_num);
            reset_dut();


            plaintext = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            key       = 256'h0000000000000000000000000000000000000000000000000000000000000000;

            start = 1;
            @(posedge clk);
            start = 0;

            while (!done) @(posedge clk);


            if (done == 1'b1) begin
                $display("Encryption 1 finished.");
            end


            reset_dut();
            plaintext = 256'h123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0;
            key       = 256'hFEDCBA9876543210FEDCBA9876543210FEDCBA9876543210FEDCBA9876543210;

            start = 1;
            @(posedge clk);
            start = 0;

            while (!done) @(posedge clk);


            #1;



            check_outputs(ciphertext, 1'b1);
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
