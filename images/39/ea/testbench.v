`timescale 1ns/1ps

module simplified_des_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] key;
    reg [63:0] plaintext;
    reg rst;
    wire [63:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simplified_des dut (
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
            @(posedge clk);
            rst = 1;
            key = 64'h0;
            plaintext = 64'h0;
            @(posedge clk);
            #2;
            rst = 0;
            $display("\n--- Reset Complete ---");
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            key = 64'h0000000000000000;
            plaintext = 64'h0000000000000000;
            #1;

            check_outputs(64'h8CA64DE9C1B123A7);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            key = 64'h0123456789ABCDEF;
            plaintext = 64'h4E6F772069732074;
            #1;

            check_outputs(64'h3FA40E8A984D4815);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            key = 64'h133457799BBCDFF1;
            plaintext = 64'h0123456789ABCDEF;
            #1;

            check_outputs(64'h85E813540F0AB405);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            key = 64'hFFFFFFFFFFFFFFFF;
            plaintext = 64'hFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(64'h7359B2163E4EDC58);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            key = 64'hAAAAAAAAAAAAAAAA;
            plaintext = 64'h5555555555555555;
            #1;

            check_outputs(64'hCB9371759695A642);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simplified_des Testbench");
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
        $dumpvars(0,clk, key, plaintext, rst, ciphertext);
    end

endmodule
