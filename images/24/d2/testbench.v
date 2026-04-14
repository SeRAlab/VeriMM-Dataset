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
            plaintext = 0;
            key = 0;
            #20;
            @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: All Zeros Pattern", test_num);

            plaintext = 256'h0000000000000000000000000000000000000000000000000000000000000000;
            key       = 256'h0000000000000000000000000000000000000000000000000000000000000000;


            repeat(15) @(posedge clk);


            #1;



            check_outputs(256'hDC95C078A2408989AD48A21492842087DC95C078A2408989AD48A21492842087);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Alternating Bits (55AA)", test_num);

            plaintext = 256'h5555555555555555555555555555555555555555555555555555555555555555;
            key       = 256'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;

            repeat(15) @(posedge clk);


            #1;



            check_outputs(256'h706F4892AA8C213456789ABCDEF01234706F4892AA8C213456789ABCDEF01234);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Incremental Byte Pattern", test_num);

            plaintext = 256'h000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F;
            key       = 256'h1F1E1D1C1B1A191817161514131211100F0E0D0C0B0A09080706050403020100;

            repeat(15) @(posedge clk);


            #1;



            check_outputs(256'hAABBCCDDEEFF00112233445566778899AABBCCDDEEFF00112233445566778899);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: All Ones Pattern", test_num);

            plaintext = {8{32'hFFFFFFFF}};
            key       = {8{32'hFFFFFFFF}};

            repeat(15) @(posedge clk);


            #1;



            check_outputs(256'hB7231451121841325987152431628374B7231451121841325987152431628374);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Key Sensitivity Pattern", test_num);

            plaintext = 256'h6bc1bee22e409f96e93d7e117393172a6bc1bee22e409f96e93d7e117393172a;
            key       = 256'h603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4;

            repeat(15) @(posedge clk);


            #1;



            check_outputs(256'hF58C8427D59B01FAD5CD5D14F9B61BAF303E1AB7C6E015112E07E608892D112A);
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
