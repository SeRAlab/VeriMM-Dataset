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
            #2 rst = 0;
            @(posedge clk);
            $display("DUT Reset sequence complete.");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: All Zeros Plaintext and Key", test_num);
            reset_dut();
            plaintext = 256'h0000000000000000000000000000000000000000000000000000000000000000;
            key       = 256'h0000000000000000000000000000000000000000000000000000000000000000;


            repeat(15) @(posedge clk);


            #1;



            check_outputs(256'hDC95C078A2408989AD373970930B6F0555D0891E14D219082F2D1F4D63102432);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: All Ones Plaintext and Key", test_num);
            reset_dut();
            plaintext = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            key       = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

            repeat(15) @(posedge clk);

            #1;


            check_outputs(256'h621532B0302068A03372B5712E1B463056023F2169542013A421D2506F231268);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Incremental Hex Pattern", test_num);
            reset_dut();
            plaintext = 256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
            key       = 256'hFEDCBA9876543210FEDCBA9876543210FEDCBA9876543210FEDCBA9876543210;

            repeat(15) @(posedge clk);

            #1;


            check_outputs(256'hA592D0134F20126857102934BB10257321098472B205126847102934BD201245);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Checkerboard Pattern (5/A)", test_num);
            reset_dut();
            plaintext = 256'h5555555555555555555555555555555555555555555555555555555555555555;
            key       = 256'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;

            repeat(15) @(posedge clk);

            #1;


            check_outputs(256'h71A2B3C4D5E6F708192A3B4C5D6E7F8071A2B3C4D5E6F708192A3B4C5D6E7F80);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Mixed Input Data", test_num);
            reset_dut();
            plaintext = 256'h6bc1bee22e409f96e93d7e117393172aae2d8a571e03ac9c9eb76fac45af8e51;
            key       = 256'h603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4;

            repeat(15) @(posedge clk);

            #1;


            check_outputs(256'h758914D16210A2B34827105928104712B2810472610283471029384756102341);
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
