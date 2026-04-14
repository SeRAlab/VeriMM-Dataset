`timescale 1ns/1ps

module aes_256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [255:0] key;
    reg [255:0] plaintext;
    reg reset;
    wire [255:0] ciphertext;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_256 dut (
        .clk(clk),
        .enable(enable),
        .key(key),
        .plaintext(plaintext),
        .reset(reset),
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
            enable = 0;
            key = 256'h0;
            plaintext = 256'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: All Zeros Plaintext and Key", test_num);
            reset_dut();

            plaintext = 256'h0;
            key       = 256'h0;
            enable    = 1;

            @(posedge clk);
            enable = 0;


            wait(done === 1'b1);
            @(posedge clk);


            #1;



            check_outputs(256'hDC95C078A24089895397CEB4B3428801DC95C078A24089895397CEB4B3428801, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Alternating Bits (0x55... / 0xAA...)", test_num);
            reset_dut();

            plaintext = {128{2'b01}};
            key       = {128{2'b10}};
            enable    = 1;

            @(posedge clk);
            enable = 0;

            wait(done === 1'b1);
            @(posedge clk);

            #1;


            check_outputs(256'h7E9C0A1B2C3D4E5F60718293A4B5C6D7E9C0A1B2C3D4E5F60718293A4B5C6D7, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: All Ones Plaintext and Key", test_num);
            reset_dut();

            plaintext = {256{1'b1}};
            key       = {256{1'b1}};
            enable    = 1;

            @(posedge clk);
            enable = 0;

            wait(done === 1'b1);
            @(posedge clk);

            #1;


            check_outputs(256'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5, 1'b1);
        end
        endtask

    task testcase004;

        reg [255:0] pattern;
        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Incremental Pattern", test_num);
            reset_dut();

            for(i=0; i<32; i=i+1) pattern[i*8 +: 8] = i;

            plaintext = pattern;
            key       = ~pattern;
            enable    = 1;

            @(posedge clk);
            enable = 0;

            wait(done === 1'b1);
            @(posedge clk);

            #1;


            check_outputs(256'h123456789ABCDEF00FEDCBA987654321123456789ABCDEF00FEDCBA987654321, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Fixed Key, Custom Plaintext", test_num);
            reset_dut();

            plaintext = 256'hDEADBEEFCAFEBABE1234567887654321DEADBEEFCAFEBABE1234567887654321;
            key       = 256'h00112233445566778899AABBCCDDEEFF00112233445566778899AABBCCDDEEFF;
            enable    = 1;

            @(posedge clk);
            enable = 0;

            wait(done === 1'b1);
            @(posedge clk);

            #1;


            check_outputs(256'hB0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_256 Testbench");
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
        $dumpvars(0,clk, enable, key, plaintext, reset, ciphertext, done);
    end

endmodule
