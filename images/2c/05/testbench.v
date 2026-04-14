`timescale 1ns/1ps

module aes_one_round_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg [127:0] plaintext;
    reg reset;
    wire [127:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_one_round dut (
        .clk(clk),
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
            plaintext = 0;
            key = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Running Testcase %03d: All Zeros", test_num);
            plaintext = 128'h00000000000000000000000000000000;
            key       = 128'h00000000000000000000000000000000;


            repeat(2) @(posedge clk);
            #1;



            #1;




            check_outputs(128'h63636363636363636363636363636363);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Running Testcase %03d: All Ones", test_num);
            plaintext = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            key       = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(128'h7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E7E);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Running Testcase %03d: Incrementing Pattern", test_num);
            plaintext = 128'h00112233445566778899AABBCCDDEEFF;
            key       = 128'h000102030405060708090A0B0C0D0E0F;

            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(128'hC097E21D5A744AD21D31A8FFC108A212);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Running Testcase %03d: Key Sensitivity", test_num);
            plaintext = 128'h00000000000000000000000000000000;
            key       = 128'h00000000000000000000000000000001;

            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(128'h1DB0432313F108235213601247120392);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_one_round Testbench");
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
        $dumpvars(0,clk, key, plaintext, reset, ciphertext);
    end

endmodule
