`timescale 1ns/1ps

module chacha20_stream_cipher_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] block_counter;
    reg clk;
    reg [255:0] key;
    reg [63:0] nonce;
    reg reset;
    wire [255:0] keystream;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_stream_cipher dut (
        .block_counter(block_counter),
        .clk(clk),
        .key(key),
        .nonce(nonce),
        .reset(reset),
        .keystream(keystream)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            key = 0;
            nonce = 0;
            block_counter = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            reset_dut();
            key = 256'h0;
            nonce = 64'h0;
            block_counter = 32'h0;


            repeat(40) @(posedge clk);



            #1;




            check_outputs(256'h76b8e0ada215c6d47a31e7e846a93c1465608f3d909b3d870c538a2d98c2073d);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Typical Key and Nonce", test_num);
            reset_dut();
            key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
            nonce = 64'h000000000000004a;
            block_counter = 32'h00000001;

            repeat(40) @(posedge clk);

            #1;


            check_outputs(256'h374e043019623651125b5969542da60790a8a641a9d94944d18809059f13e77f);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Incrementing Block Counter", test_num);
            reset_dut();
            key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
            nonce = 64'h000000000000004a;
            block_counter = 32'h00000002;

            repeat(40) @(posedge clk);

            #1;


            check_outputs(256'h22668582f309a47d25e4125f992323f46f903875323880628373302061921352);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Values (All Fs)", test_num);
            reset_dut();
            key = {256{1'b1}};
            nonce = {64{1'b1}};
            block_counter = {32{1'b1}};

            repeat(40) @(posedge clk);

            #1;


            check_outputs(256'h80d0d826d9c661a33777d56e92c68f635661413645391d4e2d2f706915f01103);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small Key Change", test_num);
            reset_dut();
            key = 256'h0000000000000000000000000000000000000000000000000000000000000001;
            nonce = 64'h0;
            block_counter = 32'h0;

            repeat(40) @(posedge clk);

            #1;


            check_outputs(256'hc133a876a445f1b181284d723703679f22204c6224e7518534e320509a259c8d);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_stream_cipher Testbench");
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
        input [255:0] expected_keystream;
        begin
            if (expected_keystream === (expected_keystream ^ keystream ^ expected_keystream)) begin
                $display("PASS");
                $display("  Outputs: keystream=%h",
                         keystream);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: keystream=%h",
                         expected_keystream);
                $display("  Got:      keystream=%h",
                         keystream);
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
        $dumpvars(0,block_counter, clk, key, nonce, reset, keystream);
    end

endmodule
