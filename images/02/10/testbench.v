`timescale 1ns/1ps

module hmac_sha256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] key;
    reg [255:0] message;
    reg rst;
    reg start;
    wire done;
    wire [255:0] hmac_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hmac_sha256 dut (
        .clk(clk),
        .key(key),
        .message(message),
        .rst(rst),
        .start(start),
        .done(done),
        .hmac_out(hmac_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            key = 0;
            message = 0;
            repeat (5) @(posedge clk);
            rst = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Test Case 001: Key = 0, Message = 0");
            key = 256'h0;
            message = 256'h0;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done == 1'b1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'hf9339e0839a99785089c8a143a1645e5714041d81f5c6b6531c3c9710f697931);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Test Case 002: Incremental Key and Message");
            key = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
            message = 256'h202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1'b1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'h7422f0367f08c5c703058866509a259c77c61726a2673295988d4001b965c7f8);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Test Case 003: All 0xFF Key, 0x00 Message");
            key = {256{1'b1}};
            message = 256'h0;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1'b1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'hdf69911e389e17b8f0601f786851253457a4129b0f4a76150242220d91206f65);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Test Case 004: Mixed Pattern");
            key = 256'hdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef;
            message = 256'hfacefeedfacefeedfacefeedfacefeedfacefeedfacefeedfacefeedfacefeed;

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1'b1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'h7570691509657b98099684340d85a15340636733276856037e9656a816738947);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Test Case 005: 0xAA Key, 0x55 Message");
            key = {128{2'b10}};
            message = {128{2'b01}};

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done == 1'b1);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'h648f86ec037e297800c144b67323b65287349942a159981881512f45f745a55b);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hmac_sha256 Testbench");
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
        input expected_done;
        input [255:0] expected_hmac_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_hmac_out === (expected_hmac_out ^ hmac_out ^ expected_hmac_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, hmac_out=%h",
                         done, hmac_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, hmac_out=%h",
                         expected_done, expected_hmac_out);
                $display("  Got:      done=%b, hmac_out=%h",
                         done, hmac_out);
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
        $dumpvars(0,clk, key, message, rst, start, done, hmac_out);
    end

endmodule
