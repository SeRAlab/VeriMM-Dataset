`timescale 1ns/1ps

module aes_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] key;
    reg [7:0] plaintext;
    wire [7:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_8bit dut (
        .clk(clk),
        .key(key),
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
            plaintext <= 8'h00;
            key <= 8'h00;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: All Zeros (Plaintext=00, Key=00)", test_num);
            plaintext <= 8'h00;
            key <= 8'h00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(model_logic(8'h00, 8'h00));
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: All Ones (Plaintext=FF, Key=FF)", test_num);
            plaintext <= 8'hFF;
            key <= 8'hFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(model_logic(8'hFF, 8'hFF));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Identity Key (Plaintext=A5, Key=00)", test_num);
            plaintext <= 8'hA5;
            key <= 8'h00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(model_logic(8'hA5, 8'h00));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Alternating Bits (Plaintext=55, Key=AA)", test_num);
            plaintext <= 8'h55;
            key <= 8'hAA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(model_logic(8'h55, 8'hAA));
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Arbitrary Pattern (Plaintext=12, Key=34)", test_num);
            plaintext <= 8'h12;
            key <= 8'h34;
            @(posedge clk);
            #2;
            #1;

            check_outputs(model_logic(8'h12, 8'h34));
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: High Plaintext, Specific Key (Plaintext=F0, Key=0F)", test_num);
            plaintext <= 8'hF0;
            key <= 8'h0F;
            @(posedge clk);
            #2;
            #1;

            check_outputs(model_logic(8'hF0, 8'h0F));
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_8bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        $dumpvars(0,clk, key, plaintext, ciphertext);
    end

endmodule
