`timescale 1ns/1ps

module aes256_encrypt_tb;

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
    aes256_encrypt dut (
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
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase %0d: All Zeros", test_num);
            plaintext = 256'h0;
            key       = 256'h0;


            repeat(20) @(posedge clk);



            #1;




            check_outputs(256'hDC95C078A2408989AD48A2149284208721492842087DC95C078A2408989AD48A);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase %0d: All Ones", test_num);
            plaintext = {8{32'hFFFFFFFF}};
            key       = {8{32'hFFFFFFFF}};

            repeat(20) @(posedge clk);

            #1;


            check_outputs(256'h70B3D5D73E0AF0333E0AF03370B3D5D770B3D5D73E0AF0333E0AF03370B3D5D7);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase %0d: Incremental Pattern", test_num);
            plaintext = 256'h00112233445566778899AABBCCDDEEFF00112233445566778899AABBCCDDEEFF;
            key       = 256'hFFFFEEEEDDDDCCCCBBBBAAAA9999888877776666555544443333222211110000;

            repeat(20) @(posedge clk);

            #1;


            check_outputs(256'hA5A5A5A5A5A5A5A50123456789ABCDEF0123456789ABCDEFA5A5A5A5A5A5A5A5);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase %0d: Alternating Bits", test_num);
            plaintext = 256'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            key       = 256'h5555555555555555555555555555555555555555555555555555555555555555;

            repeat(20) @(posedge clk);

            #1;


            check_outputs(256'hB6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase %0d: Walking One", test_num);
            plaintext = 256'h1;
            key       = 256'h8000000000000000000000000000000000000000000000000000000000000000;

            repeat(20) @(posedge clk);

            #1;


            check_outputs(256'hF0F0F0F0F0F0F0F0E0E0E0E0E0E0E0E0D0D0D0D0D0D0D0D0C0C0C0C0C0C0C0C0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes256_encrypt Testbench");
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
