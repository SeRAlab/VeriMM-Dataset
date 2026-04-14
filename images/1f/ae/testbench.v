`timescale 1ns/1ps

module aes_256_encrypt_tb;

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
    aes_256_encrypt dut (
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
            repeat (5) @(posedge clk);
            rst = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Encryption with All-Zeros Key and Plaintext", test_num);
            reset_dut();


            key       = 256'h0000000000000000000000000000000000000000000000000000000000000000;
            plaintext = 256'h0000000000000000000000000000000000000000000000000000000000000000;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done === 1'b1);



            #1;




            check_outputs(256'h50e396ef9436270d4f37803732c25390623a9d70104f4625b03513b63294376b, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Encryption with Incremental Pattern", test_num);
            reset_dut();


            key       = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
            plaintext = 256'h0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done === 1'b1);


            #1;



            check_outputs(256'h8ea2b7ca516745bfeafc49904b496089b1446e3274226d70a3501a3769c0d9a6, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: High Entropy Pattern Test", test_num);
            reset_dut();


            key       = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000;
            plaintext = 256'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A55A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done === 1'b1);


            #1;



            check_outputs(256'hbb8400039239399889423982348923491230482304832048efabe89341203948, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Back-to-Back Reset Test", test_num);
            reset_dut();

            key       = 256'h1234567812345678123456781234567812345678123456781234567812345678;
            plaintext = 256'hFEDCBA9876543210FEDCBA9876543210FEDCBA9876543210FEDCBA9876543210;

            @(posedge clk);
            start = 1;
            repeat(5) @(posedge clk);

            $display("  Interrupting with reset mid-process...");
            reset_dut();

            start = 1;
            @(posedge clk);
            start = 0;

            wait(done === 1'b1);


            #1;



            check_outputs(256'h7f9d123048923490812304891230481203498102349810239481203948120394, 1'b1);
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
