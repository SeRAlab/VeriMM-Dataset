`timescale 1ns/1ps

module aes_round_tb;

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
    aes_round dut (
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
            key = 128'h0;
            plaintext = 128'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (Plaintext and Key)", test_num);
            reset_dut();
            key = 128'h00000000000000000000000000000000;
            plaintext = 128'h00000000000000000000000000000000;


            repeat(2) @(posedge clk);






            #1;







            check_outputs(128'hb588179e1622ec90a16c029167232320);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: FIPS-197 Standard Vector", test_num);
            reset_dut();
            key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
            plaintext = 128'h3243f6a8885a308d313198a2e0370734;

            repeat(2) @(posedge clk);



            #1;




            check_outputs(128'ha49c7ff2689f352b6b5be043026a5049);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits", test_num);
            reset_dut();
            key = 128'hffffffffffffffffffffffffffffffff;
            plaintext = 128'haaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;

            repeat(2) @(posedge clk);



            #1;




            check_outputs(128'hb3b7d143003009586111a43a60a7e620);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Incremental Byte Values", test_num);
            reset_dut();
            key = 128'h000102030405060708090a0b0c0d0e0f;
            plaintext = 128'h00112233445566778899aabbccddeeff;

            repeat(2) @(posedge clk);



            #1;




            check_outputs(128'ha1f6258c877d5fcd8964484b7a7d20a7);
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
        $dumpvars(0,clk, key, plaintext, reset, ciphertext);
    end

endmodule
