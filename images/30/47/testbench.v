`timescale 1ns/1ps

module aes_128_encryption_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [127:0] key;
    reg [127:0] plaintext;
    reg rst;
    wire [127:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_128_encryption dut (
        .clk(clk),
        .enable(enable),
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
            enable = 0;
            plaintext = 0;
            key = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: All Zeros Plaintext and Key", test_num);

            plaintext = 128'h00000000000000000000000000000000;
            key       = 128'h00000000000000000000000000000000;
            enable    = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h01000000010000000100000001000000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: NIST Specified Vector", test_num);

            plaintext = 128'h00112233445566778899aabbccddeeff;
            key       = 128'h000102030405060708090a0b0c0d0e0f;
            enable    = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(128'hdf1f1818192a201c2230301925392015);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Enable Signal Control", test_num);


            plaintext = 128'h00000000000000000000000000000000;
            key       = 128'h00000000000000000000000000000000;
            enable    = 1;
            @(posedge clk);
            #1;
            reg [127:0] prev_out;
            prev_out = ciphertext;


            plaintext = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            enable    = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(prev_out);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Alternating Pattern Pattern", test_num);

            plaintext = 128'h55555555555555555555555555555555;
            key       = 128'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
            enable    = 1;

            @(posedge clk);
            #2;

            #1;


            check_outputs(128'h71641010303e302c33272733220c3316);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Reset during operation", test_num);

            plaintext = 128'h0123456789ABCDEF0123456789ABCDEF;
            key       = 128'hFEDCBA9876543210FEDCBA9876543210;
            enable    = 1;

            @(posedge clk);
            #1;
            rst = 1;
            @(posedge clk);
            #2;


            if (ciphertext === 128'h0) begin
                $display("PASS: Reset cleared output");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Reset did not clear output. Got: %h", ciphertext);
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_128_encryption Testbench");
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
        input [127:0] expected_ciphertext;
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
        $dumpvars(0,clk, enable, key, plaintext, rst, ciphertext);
    end

endmodule
