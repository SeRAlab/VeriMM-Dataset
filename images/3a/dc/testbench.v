`timescale 1ns/1ps

module DES_round_tb;

    // Testbench signals (sequential circuit)
    reg [63:0] key;
    reg [63:0] plaintext;
    reg start;
    wire [63:0] ciphertext;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DES_round dut (
        .key(key),
        .plaintext(plaintext),
        .start(start),
        .ciphertext(ciphertext),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        start = 0;
        forever #5 start = ~start;
    end

        task reset_dut;

        begin
            $display("\nResetting DUT...");
            key <= 64'h0;
            plaintext <= 64'h0;

            @(posedge start);
            @(posedge start);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: All Zeros", test_num);

            plaintext = 64'h0000000000000000;
            key       = 64'h0000000000000000;


            wait(done == 1);
            @(posedge start);



            #1;




            check_outputs(64'hDA02CE3A89213421, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Standard Vector", test_num);

            plaintext = 64'h0123456789ABCDEF;
            key       = 64'h133457799BBCDFF1;

            wait(done == 1);
            @(posedge start);


            #1;



            check_outputs(64'h0A31215902070F69, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Alternating Bits", test_num);

            plaintext = 64'hAAAAAAAAAAAAAAAA;
            key       = 64'h5555555555555555;

            wait(done == 1);
            @(posedge start);


            #1;



            check_outputs(64'h066A00A0266A467F, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: All Ones Plaintext", test_num);

            plaintext = 64'hFFFFFFFFFFFFFFFF;
            key       = 64'h0000000000000000;

            wait(done == 1);
            @(posedge start);

            #1;


            check_outputs(64'hE30639D27756184C, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DES_round Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_done;
        begin
            if (expected_ciphertext === (expected_ciphertext ^ ciphertext ^ expected_ciphertext) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: ciphertext=%h, done=%b",
                         ciphertext, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ciphertext=%h, done=%b",
                         expected_ciphertext, expected_done);
                $display("  Got:      ciphertext=%h, done=%b",
                         ciphertext, done);
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
        $dumpvars(0,key, plaintext, start, ciphertext, done);
    end

endmodule
