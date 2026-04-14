`timescale 1ns/1ps

module des_encryption_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [55:0] key;
    reg [63:0] plaintext;
    reg reset;
    wire [63:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    des_encryption dut (
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
            key = 0;
            plaintext = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: All Zeros", test_num);
            reset_dut();
            key = 56'h00000000000000;
            plaintext = 64'h0000000000000000;

            repeat (20) @(posedge clk);

            #1;


            check_outputs(64'h8CA64DE9C1B123A7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %02d: All Ones", test_num);
            reset_dut();
            key = 56'hFFFFFFFFFFFFFF;
            plaintext = 64'hFFFFFFFFFFFFFFFF;
            repeat (20) @(posedge clk);
            #1;

            check_outputs(64'h7359B2163E4EDC58);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Alternating Bits", test_num);
            reset_dut();
            key = 56'hAAAAAAAAAAAAAAAA;
            plaintext = 64'h5555555555555555;
            repeat (20) @(posedge clk);
            #1;

            check_outputs(64'hCB678E0124096013);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Sequence Pattern", test_num);
            reset_dut();
            key = 56'h133457799BBCDF;
            plaintext = 64'h0123456789ABCDEF;
            repeat (20) @(posedge clk);
            #1;

            check_outputs(64'h85E813540F0AB405);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %03d: Avalanche Effect (Change 1 bit)", test_num);
            reset_dut();
            key = 56'h133457799BBCDF;
            plaintext = 64'h0123456789ABCDFE;
            repeat (20) @(posedge clk);

            #1;


            check_outputs(64'h0517E1D8B4D661D4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("des_encryption Testbench");
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
        input [63:0] expected_ciphertext;
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
