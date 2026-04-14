`timescale 1ns/1ps

module rsa_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [7:0] plaintext;
    wire [7:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rsa_encrypt dut (
        .clk(clk),
        .enable(enable),
        .plaintext(plaintext),
        .ciphertext(ciphertext)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            plaintext = 8'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Plaintext = 2", test_num);
            plaintext = 8'd2;
            enable = 1;
            repeat (10) @(posedge clk);
            enable = 0;
            #1;

            check_outputs(8'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Plaintext = 4", test_num);
            plaintext = 8'd4;
            enable = 1;
            repeat (10) @(posedge clk);
            enable = 0;
            #1;

            check_outputs(8'd31);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Plaintext = 5", test_num);
            plaintext = 8'd5;
            enable = 1;
            repeat (10) @(posedge clk);
            enable = 0;
            #1;

            check_outputs(8'd26);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Plaintext = 10", test_num);
            plaintext = 8'd10;
            enable = 1;
            repeat (10) @(posedge clk);
            enable = 0;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Plaintext = 1", test_num);
            plaintext = 8'd1;
            enable = 1;
            repeat (10) @(posedge clk);
            enable = 0;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Plaintext = 0", test_num);
            plaintext = 8'd0;
            enable = 1;
            repeat (10) @(posedge clk);
            enable = 0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Plaintext = 7", test_num);
            plaintext = 8'd7;
            enable = 1;
            repeat (10) @(posedge clk);
            enable = 0;
            #1;

            check_outputs(8'd13);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Plaintext = 32", test_num);
            plaintext = 8'd32;
            enable = 1;
            repeat (10) @(posedge clk);
            enable = 0;
            #1;

            check_outputs(8'd32);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rsa_encrypt Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_ciphertext;
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
        $dumpvars(0,clk, enable, plaintext, ciphertext);
    end

endmodule
