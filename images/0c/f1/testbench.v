`timescale 1ns/1ps

module hmac_sha256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg [255:0] message;
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
            start = 0;
            key = 128'h0;
            message = 256'h0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: All Zeros");
            reset_dut();
            test_num = 1;


            key = 128'h0;
            message = 256'h0;


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'hb916a24696010534c000c2836253902996d93425f38072046830501869e54a5a);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Sequential Values");
            reset_dut();
            test_num = 2;


            key = 128'h000102030405060708090a0b0c0d0e0f;
            message = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'he4395669f1090333d024e1388b13d2f9d5069796859f77f975440a1b87a8f804);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: All Ones");
            reset_dut();
            test_num = 3;


            key = 128'hffffffffffffffffffffffffffffffff;
            message = 256'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'he5287f3b610c55047b74681329a473f32c39e24741f237f8f62f02f6ca2677b5);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Mixed Pattern");
            reset_dut();
            test_num = 4;


            key = 128'hdeadbeefcafebabefacedeadbeefface;
            message = 256'h0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef;


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done);
            @(posedge clk);


            #1;



            check_outputs(1'b1, 256'h35831206f69e6b4d32039268f7734103632906666687a718c39e8d42d54e4277);
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
        $dumpvars(0,clk, key, message, start, done, hmac_out);
    end

endmodule
