`timescale 1ns/1ps

module aes_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg [127:0] plaintext;
    wire [127:0] ciphertext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_encrypt dut (
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
            @(negedge clk);
            key = 128'h0;
            plaintext = 128'h0;

            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: All Zeros", test_num);
            reset_dut();
            plaintext = 128'h0;
            key = 128'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h0 ^ 128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: All Ones Plaintext, Zero Key", test_num);
            reset_dut();
            plaintext = {128{1'b1}};
            key = 128'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs({128{1'b1}} ^ 128'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Zero Plaintext, All Ones Key", test_num);
            reset_dut();
            plaintext = 128'h0;
            key = {128{1'b1}};
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h0 ^ {128{1'b1}});
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Alternating Bit Patterns", test_num);
            reset_dut();
            plaintext = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            key       = 128'h55555555555555555555555555555555;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Hex Value Mix", test_num);
            reset_dut();
            plaintext = 128'hDEADBEEFCAFEBABE1234567887654321;
            key       = 128'hFEEDFACECODEBAD109876543210FEDCB;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'hDEADBEEFCAFEBABE1234567887654321 ^ 128'hFEEDFACECODEBAD109876543210FEDCB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_encrypt Testbench");
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
        input [127:0] expected_ciphertext;
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
