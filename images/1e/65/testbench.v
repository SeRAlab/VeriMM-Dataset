`timescale 1ns/1ps

module des_encryption_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] key;
    reg [7:0] plaintext;
    reg reset;
    wire [7:0] ciphertext;

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
            plaintext = 8'h00;
            key = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            plaintext = 8'h00;
            key = 8'h00;
            @(posedge clk);
            #1 #1;
 check_outputs(calculate_expected(8'h00, 8'h00));
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            plaintext = 8'hFF;
            key = 8'h00;
            @(posedge clk);
            #1 #1;
 check_outputs(calculate_expected(8'hFF, 8'h00));
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            plaintext = 8'h00;
            key = 8'hFF;
            @(posedge clk);
            #1 #1;
 check_outputs(calculate_expected(8'h00, 8'hFF));
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            plaintext = 8'hAA;
            key = 8'h55;
            @(posedge clk);
            #1 #1;
 check_outputs(calculate_expected(8'hAA, 8'h55));
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            plaintext = 8'h12;
            key = 8'h34;
            @(posedge clk);
            #1 #1;
 check_outputs(calculate_expected(8'h12, 8'h34));
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            plaintext = 8'hF0;
            key = 8'h0F;
            @(posedge clk);
            #1 #1;
 check_outputs(calculate_expected(8'hF0, 8'h0F));
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
        $dumpvars(0,clk, key, plaintext, reset, ciphertext);
    end

endmodule
