`timescale 1ns/1ps

module HMAC_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] key;
    reg [255:0] message;
    reg rst;
    reg start;
    wire done;
    wire [255:0] hmac_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    HMAC dut (
        .clk(clk),
        .key(key),
        .message(message),
        .rst(rst),
        .start(start),
        .done(done),
        .hmac_output(hmac_output)
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
            #20;
            rst = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: All Zeros", test_num);
            reset_dut();

            key = 256'h0;
            message = 256'h0;
            start = 1;
            #10;
            start = 0;


            wait(done);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 256'hb613679a0814d9ec772f95d778c30911497537b23305d301b9e0891db95c1159);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: ASCII Pattern", test_num);
            reset_dut();


            key = 256'h6b65796b65796b65796b65796b65796b65796b65796b65796b65796b65796b65;

            message = 256'h6d6573736167656d6573736167656d6573736167656d6573736167656d657373;

            start = 1;
            #10;
            start = 0;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 256'h5e99c5936531398c8c4f037651c6e1183c5005858f7004f8615c449c20a1f054);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: All Ones (FF)", test_num);
            reset_dut();

            key = {256{1'b1}};
            message = {256{1'b1}};

            start = 1;
            #10;
            start = 0;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 256'h820684f88e5d28b12369680c2f8832a8291f09855529f79659b9a67e23101c59);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Mixed Hex Pattern", test_num);
            reset_dut();

            key = 256'h0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20;
            message = 256'hdeadbeefcafebabefacedeadbeefcafebabefacedeadbeefcafebafacedead;

            start = 1;
            #10;
            start = 0;

            wait(done);
            @(posedge clk);

            #1;


            check_outputs(1'b1, 256'h7810e4a77884d8520779796e6807c6f06a096c469f37500529d899557b494d48);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("HMAC Testbench");
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
        input [255:0] expected_hmac_output;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_hmac_output === (expected_hmac_output ^ hmac_output ^ expected_hmac_output)) begin
                $display("PASS");
                $display("  Outputs: done=%b, hmac_output=%h",
                         done, hmac_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, hmac_output=%h",
                         expected_done, expected_hmac_output);
                $display("  Got:      done=%b, hmac_output=%h",
                         done, hmac_output);
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
        $dumpvars(0,clk, key, message, rst, start, done, hmac_output);
    end

endmodule
