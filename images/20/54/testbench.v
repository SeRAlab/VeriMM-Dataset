`timescale 1ns/1ps

module des_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] plaintext;
    reg reset;
    wire [63:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    des_module dut (
        .clk(clk),
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
            plaintext = 64'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros Plaintext", test_num);
            reset_dut();

            plaintext = 64'h0000000000000000;


            @(posedge clk);
            #2;

            #1;


            check_outputs(64'h8CA64DE9C1B123A7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones Plaintext", test_num);
            reset_dut();

            plaintext = 64'hFFFFFFFFFFFFFFFF;

            @(posedge clk);
            #2;

            #1;


            check_outputs(64'h7359B2163E4EDC58);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits (55...)", test_num);
            reset_dut();

            plaintext = 64'h5555555555555555;

            @(posedge clk);
            #2;

            #1;


            check_outputs(64'hCB67017036650356);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sequential Hex Pattern", test_num);
            reset_dut();

            plaintext = 64'h0123456789ABCDEF;

            @(posedge clk);
            #2;

            #1;


            check_outputs(64'hD5D44FF720683D0D);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Verify Reset Suppression", test_num);


            reset = 1;
            plaintext = 64'hFFFFFFFFFFFFFFFF;
            @(posedge clk);
            #2;



            if (ciphertext == 64'h7359B2163E4EDC58) begin
                $display("FAIL: Module processed data while reset was high");
                fail_count = fail_count + 1;
            end else begin
                $display("PASS: Module ignored input during reset");
                pass_count = pass_count + 1;
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
        $display("des_module Testbench");
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
        $dumpvars(0,clk, plaintext, reset, ciphertext);
    end

endmodule
