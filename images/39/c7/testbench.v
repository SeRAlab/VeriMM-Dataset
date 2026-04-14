`timescale 1ns/1ps

module aes_round_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] plaintext;
    reg reset;
    reg [127:0] round_key;
    wire [127:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_round dut (
        .clk(clk),
        .plaintext(plaintext),
        .reset(reset),
        .round_key(round_key),
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
            round_key = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All Zeros Input/Key", test_num);
            reset_dut();
            plaintext = 128'h00000000000000000000000000000000;
            round_key = 128'h00000000000000000000000000000000;
            @(posedge clk);
            #1 #1;
 check_outputs(128'h63636363636363636363636363636363);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: FIPS-197 Round 1 Reference", test_num);
            reset_dut();
            plaintext = 128'h193de3bea0f4e22b9ac68d2ae9f84808;
            round_key = 128'ha0fafe1788542cb123a339392a6c7605;
            @(posedge clk);
            #1 #1;
 check_outputs(128'ha49c7ff2689f352b6b5bef48f59b5c30);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: FIPS-197 Round 2 Reference", test_num);
            reset_dut();
            plaintext = 128'ha49c7ff2689f352b6b5bef48f59b5c30;
            round_key = 128'hf2c295f27a96b9435935807a7359f67f;
            @(posedge clk);
            #1 #1;
 check_outputs(128'haa25af7372325fed5a070352851af3f5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: All 0xFF Input, Zero Key", test_num);
            reset_dut();
            plaintext = 128'hffffffffffffffffffffffffffffffff;
            round_key = 128'h00000000000000000000000000000000;
            @(posedge clk);
            #1 #1;
 check_outputs(128'h16161616161616161616161616161616);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_round Testbench");
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
        $dumpvars(0,clk, plaintext, reset, round_key, ciphertext);
    end

endmodule
