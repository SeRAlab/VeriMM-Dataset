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
            key = 0;
            plaintext = 0;
            #20;
            rst = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: All Zeros", test_num);
            reset_dut();

            plaintext = 256'h0;
            key       = 256'h0;


            wait(done == 1'b1);
            @(posedge clk);



            #1;




            check_outputs(256'h62909267666981881515B215E5830E96E6B05572629C67778994C3F0828551E5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: All Ones", test_num);
            reset_dut();

            plaintext = {64{4'hF}};
            key       = {64{4'hF}};

            wait(done == 1'b1);
            @(posedge clk);

            #1;


            check_outputs(256'h9F93F421D6084C8F9F93F421D6084C8F9F93F421D6084C8F9F93F421D6084C8F, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Incremental Pattern", test_num);
            reset_dut();

            plaintext = 256'h000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F;
            key       = 256'h1F1E1D1C1B1A191817161514131211100F0E0D0C0B0A09080706050403020100;

            wait(done == 1'b1);
            @(posedge clk);

            #1;


            check_outputs(256'hA32B870933C1488F35F4C742D93122B4870933C1488F35F4C742D93122B4A32B, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Alternating Bits", test_num);
            reset_dut();

            plaintext = 256'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            key       = 256'h5555555555555555555555555555555555555555555555555555555555555555;

            wait(done == 1'b1);
            @(posedge clk);

            #1;


            check_outputs(256'hBD4C8D890C5D8B4D4F5A6F1D0E4A1C2B0C5D8B4D4F5A6F1D0E4A1C2BBD4C8D89, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Mixed High-Low", test_num);
            reset_dut();

            plaintext = 256'hFFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000;
            key       = 256'h00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF;

            wait(done == 1'b1);
            @(posedge clk);

            #1;


            check_outputs(256'h42A1C3B4E5F60718293A4B5C6D7E8F900718293A4B5C6D7E8F9042A1C3B4E5F6, 1'b1);
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
