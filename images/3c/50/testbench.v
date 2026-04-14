`timescale 1ns/1ps

module aes_round_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] plaintext;
    reg [255:0] round_key;
    reg rst;
    wire [255:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_round dut (
        .clk(clk),
        .plaintext(plaintext),
        .round_key(round_key),
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
            rst = 1;
            plaintext = 0;
            round_key = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: All Zeros");
            reset_dut();
            plaintext = 256'h0;
            round_key = 256'h0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(256'h6363636363636363636363636363636363636363636363636363636363636363);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: All Ones");
            reset_dut();
            plaintext = {8{32'hFFFFFFFF}};
            round_key = {8{32'hFFFFFFFF}};
            @(posedge clk);
            #2;


            #1;



            check_outputs(256'h11E711E711E711E711E711E711E711E711E711E711E711E711E711E711E711E7);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Incremental Data");
            reset_dut();
            plaintext = 256'h000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F;
            round_key = 256'h0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(256'h71676D1F31F91B1F2063D7D7614FA561F29C35F92671A5A5C2B472714D251C25);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Key influence test");
            reset_dut();
            plaintext = 256'h0;
            round_key = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(256'h9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C9C);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Mixed Pattern");
            reset_dut();
            plaintext = 256'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5;
            round_key = 256'h5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A;
            @(posedge clk);
            #2;
            #1;

            check_outputs(256'hB692B692B692B692B692B692B692B692B692B692B692B692B692B692B692B692);
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
        input [255:0] expected_ciphertext;
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
        $dumpvars(0,clk, plaintext, round_key, rst, ciphertext);
    end

endmodule
