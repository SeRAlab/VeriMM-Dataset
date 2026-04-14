`timescale 1ns/1ps

module aes_256_encrypt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] key;
    reg [255:0] plaintext;
    reg reset;
    reg start;
    wire [255:0] ciphertext;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_256_encrypt dut (
        .clk(clk),
        .key(key),
        .plaintext(plaintext),
        .reset(reset),
        .start(start),
        .ciphertext(ciphertext),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        start = 0;
        key = 0;
        plaintext = 0;
        repeat(2) @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %03d: All Zeros Input", test_num);
        reset_dut();

        key = 256'h0;
        plaintext = 256'h0;

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;


        while (!done) @(posedge clk);



        #1;




        check_outputs(256'hdc95c078a2408989ad48a21492842087b310422d4988866f352e1e073c6750d7, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %03d: All Ones Plaintext", test_num);
        reset_dut();

        key = 256'h0;
        plaintext = {256{1'b1}};

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        while (!done) @(posedge clk);


        #1;



        check_outputs(256'h757099f6b90760f383e20600a94e7737e40854495b45c2698944d1885f818804, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %03d: Swapped Key and Data", test_num);
        reset_dut();

        key = 256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
        plaintext = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000;

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        while (!done) @(posedge clk);


        #1;



        check_outputs(256'h783e45903b22e176c5966606f378a50f009945068212674e1291882433091122, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %03d: Alternating Bits", test_num);
        reset_dut();

        key = 256'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
        plaintext = 256'h5555555555555555555555555555555555555555555555555555555555555555;

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        while (!done) @(posedge clk);


        #1;



        check_outputs(256'h3344556677889900aabbccddeeff11223344556677889900aabbccddeeff1122, 1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_256_encrypt Testbench");
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
        input [255:0] expected_ciphertext;
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
        $dumpvars(0,clk, key, plaintext, reset, start, ciphertext, done);
    end

endmodule
