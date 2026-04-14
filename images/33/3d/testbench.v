`timescale 1ns/1ps

module aes_128_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg [127:0] plaintext;
    reg rst;
    wire [127:0] ciphertext;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_128 dut (
        .clk(clk),
        .key(key),
        .plaintext(plaintext),
        .rst(rst),
        .ciphertext(ciphertext),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            plaintext = 128'b0;
            key = 128'b0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: NIST KAT Vector 1", test_num);
            reset_dut();


            @(negedge clk);
            key       = 128'h000102030405060708090a0b0c0d0e0f;
            plaintext = 128'h00112233445566778899aabbccddeeff;


            @(posedge clk);
            #2;


            #1;



            check_outputs(128'h69c4e0d86a7b0430d8cdb78070b4c55a, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Plaintext and Key", test_num);
            reset_dut();

            @(negedge clk);
            key       = 128'h00000000000000000000000000000000;
            plaintext = 128'h00000000000000000000000000000000;

            @(posedge clk);
            #2;


            #1;



            check_outputs(128'h66e94bd4ef8a2c3b884cfa59ca342b2e, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: FIPS-197 Appendix B", test_num);
            reset_dut();

            @(negedge clk);
            key       = 128'h2b7e151628aed2a6abf7158809cf4f3c;
            plaintext = 128'h3243f6a8885a308d313198a2e0370734;

            @(posedge clk);
            #2;


            #1;



            check_outputs(128'h3925841d02dc09fbdc118597196a0b32, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Plaintext with Zero Key", test_num);
            reset_dut();

            @(negedge clk);
            key       = 128'h00000000000000000000000000000000;
            plaintext = 128'hffffffffffffffffffffffffffffffff;

            @(posedge clk);
            #2;


            #1;



            check_outputs(128'ha380e227918a931a2936a2824707198a, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_128 Testbench");
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
        input expected_ready;
        begin
            if (expected_ciphertext === (expected_ciphertext ^ ciphertext ^ expected_ciphertext) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: ciphertext=%h, ready=%b",
                         ciphertext, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ciphertext=%h, ready=%b",
                         expected_ciphertext, expected_ready);
                $display("  Got:      ciphertext=%h, ready=%b",
                         ciphertext, ready);
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
        $dumpvars(0,clk, key, plaintext, rst, ciphertext, ready);
    end

endmodule
