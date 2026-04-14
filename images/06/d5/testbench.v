`timescale 1ns/1ps

module DES_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] plaintext;
    reg reset;
    wire [63:0] ciphertext;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DES dut (
        .clk(clk),
        .plaintext(plaintext),
        .reset(reset),
        .ciphertext(ciphertext),
        .valid(valid)
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
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros Plaintext", test_num);
        reset_dut();

        plaintext = 64'h0000000000000000;


        wait(valid === 1'b1);


        @(posedge clk);
        #1;


        #1;



        check_outputs(64'h8ca64de9c1b123a7, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones Plaintext", test_num);
        reset_dut();

        plaintext = 64'hFFFFFFFFFFFFFFFF;

        wait(valid === 1'b1);
        @(posedge clk);
        #1;


        #1;



        check_outputs(64'h7359b2163e4edc58, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Incremental Hex Pattern", test_num);
        reset_dut();

        plaintext = 64'h0123456789ABCDEF;

        wait(valid === 1'b1);
        @(posedge clk);
        #1;


        #1;



        check_outputs(64'h3c10455050518349, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bit Pattern (0101...)", test_num);
        reset_dut();

        plaintext = 64'h5555555555555555;

        wait(valid === 1'b1);
        @(posedge clk);
        #1;


        #1;



        check_outputs(64'hcb658f8863f3503d, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bit Pattern (1010...)", test_num);
        reset_dut();

        plaintext = 64'hAAAAAAAAAAAAAAAA;

        wait(valid === 1'b1);
        @(posedge clk);
        #1;


        #1;



        check_outputs(64'h3209594589d34341, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DES Testbench");
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
        input expected_valid;
        begin
            if (expected_ciphertext === (expected_ciphertext ^ ciphertext ^ expected_ciphertext) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: ciphertext=%h, valid=%b",
                         ciphertext, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ciphertext=%h, valid=%b",
                         expected_ciphertext, expected_valid);
                $display("  Got:      ciphertext=%h, valid=%b",
                         ciphertext, valid);
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
        $dumpvars(0,clk, plaintext, reset, ciphertext, valid);
    end

endmodule
