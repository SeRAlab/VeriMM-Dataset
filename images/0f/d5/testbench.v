`timescale 1ns/1ps

module aes_256_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [255:0] key;
    reg [255:0] plaintext;
    reg reset;
    wire [255:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_256_encrypt dut (
        .clk(clk),
        .enable(enable),
        .key(key),
        .plaintext(plaintext),
        .reset(reset),
        .ciphertext(ciphertext)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            key = 0;
            plaintext = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros Input", test_num);
            reset_dut();

            plaintext = 256'h0;
            key       = 256'h0;
            enable    = 1;


            repeat (100) @(posedge clk);



            #1;




            check_outputs(256'hdc95c078a2408989ad35807914f47919864235e168869c3669146199a694639e);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones Input", test_num);
            reset_dut();

            plaintext = {256{1'b1}};
            key       = {256{1'b1}};
            enable    = 1;

            repeat (100) @(posedge clk);

            #1;


            check_outputs(256'h53443a5985876356678a101292080344d9302634d28362615462619028375253);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Incremental Pattern", test_num);
            reset_dut();

            plaintext = 256'h00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff;
            key       = 256'hffeeddccbbaa99887766554433221100ffeeddccbbaa99887766554433221100;
            enable    = 1;

            repeat (100) @(posedge clk);

            #1;


            check_outputs(256'h982345982374abdf932847529348752398472398472398472398472398472398);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable Toggle Test", test_num);
            reset_dut();

            plaintext = 256'hdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef;
            key       = 256'h0123456789abcdeffedcba98765432100123456789abcdeffedcba9876543210;


            enable = 0;
            repeat (10) @(posedge clk);


            enable = 1;
            repeat (100) @(posedge clk);

            #1;


            check_outputs(256'h7346283461238476123847612384761238476123847612384761238476123847);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Key Change Test", test_num);
            reset_dut();

            plaintext = 256'h5555555555555555555555555555555555555555555555555555555555555555;
            key       = 256'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
            enable    = 1;

            repeat (100) @(posedge clk);

            #1;


            check_outputs(256'h1234abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234abcd1234abcd);
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
        $dumpvars(0,clk, enable, key, plaintext, reset, ciphertext);
    end

endmodule
