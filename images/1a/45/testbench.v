`timescale 1ns/1ps

module AES_AddRoundKey_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] plaintext;
    reg [127:0] round_key;
    wire [127:0] encrypted_text;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AES_AddRoundKey dut (
        .clk(clk),
        .plaintext(plaintext),
        .round_key(round_key),
        .encrypted_text(encrypted_text)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            plaintext = 128'h0;
            round_key = 128'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (0 ^ 0)", test_num);
            reset_dut();
            plaintext = 128'h0;
            round_key = 128'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity (Data ^ 0)", test_num);
            reset_dut();
            plaintext = 128'hDEADBEEFCAFEBABE1337C0DEFEEDFACE;
            round_key = 128'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'hDEADBEEFCAFEBABE1337C0DEFEEDFACE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Cancellation (F ^ F)", test_num);
            reset_dut();
            plaintext = {4{32'hFFFFFFFF}};
            round_key = {4{32'hFFFFFFFF}};
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: NIST Vector XOR", test_num);
            reset_dut();

            plaintext = 128'h3243f6a8885a308d313198a2e0370734;
            round_key = 128'h2b7e151628aed2a6abf7158809cf4f3c;

            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h193de3bea0f4e22b9acf8d2ae9f84808);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bit Patterns", test_num);
            reset_dut();
            plaintext = {4{32'h55555555}};
            round_key = {4{32'hAAAAAAAA}};
            @(posedge clk);
            #2;
            #1;

            check_outputs({4{32'hFFFFFFFF}});
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AES_AddRoundKey Testbench");
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
        input [127:0] expected_encrypted_text;
        begin
            if (expected_encrypted_text === (expected_encrypted_text ^ encrypted_text ^ expected_encrypted_text)) begin
                $display("PASS");
                $display("  Outputs: encrypted_text=%h",
                         encrypted_text);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encrypted_text=%h",
                         expected_encrypted_text);
                $display("  Got:      encrypted_text=%h",
                         encrypted_text);
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
        $dumpvars(0,clk, plaintext, round_key, encrypted_text);
    end

endmodule
