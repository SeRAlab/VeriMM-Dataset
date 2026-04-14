`timescale 1ns/1ps

module aes_256_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] key;
    reg [127:0] plaintext;
    reg rst;
    wire [127:0] ciphertext;

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
            key = 0;
            plaintext = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %03d: All Zeros", test_num);
            reset_dut();

            plaintext = 128'h00000000000000000000000000000000;
            key = 256'h0000000000000000000000000000000000000000000000000000000000000000;


            repeat(12) @(posedge clk);



            #1;




            check_outputs(128'hdc95c078a1138073747ab44a648a4439);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %02d: Specific Pattern", test_num);
            reset_dut();

            plaintext = 128'h6bc1bee22e409f96e93d7e117393172a;
            key = 256'h603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4;

            repeat(12) @(posedge clk);

            #1;


            check_outputs(128'hf400977227658709320697960309995c);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %03d: All Fs", test_num);
            reset_dut();

            plaintext = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            key = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

            repeat(12) @(posedge clk);

            #1;


            check_outputs(128'h69611b88e1471718037d04e466d113f3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %04d: Alternating Bits", test_num);
            reset_dut();

            plaintext = 128'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5;
            key = 256'h5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A;

            repeat(12) @(posedge clk);

            #1;


            check_outputs(128'h561f3807205191264c70034a7c030d52);
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
        $dumpvars(0,clk, key, plaintext, rst, ciphertext);
    end

endmodule
