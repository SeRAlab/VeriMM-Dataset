`timescale 1ns/1ps

module hmac_sha256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg [127:0] message;
    reg rst;
    wire [127:0] hmac;

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
        .hmac(hmac)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            key = 128'h0;
            message = 128'h0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros (Key=0, Msg=0)", test_num);
            reset_dut();
            key = 128'h0;
            message = 128'h0;


            repeat (250) @(posedge clk);


            #1;



            check_outputs(128'hb6136a3949802e0d486591918ef39534);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones Key, All Zeros Message", test_num);
            reset_dut();
            key = 128'hffffffffffffffffffffffffffffffff;
            message = 128'h0;

            repeat (250) @(posedge clk);

            #1;


            check_outputs(128'hc8990105342797e5513d8d6480b080f5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros Key, All Ones Message", test_num);
            reset_dut();
            key = 128'h0;
            message = 128'hffffffffffffffffffffffffffffffff;

            repeat (250) @(posedge clk);

            #1;


            check_outputs(128'h63704289899015e1284489a2468165b5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones Key, All Ones Message", test_num);
            reset_dut();
            key = 128'hffffffffffffffffffffffffffffffff;
            message = 128'hffffffffffffffffffffffffffffffff;

            repeat (250) @(posedge clk);

            #1;


            check_outputs(128'h0f9302636a04f2f0b9f91a590c8b939e);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Incremental Patterns", test_num);
            reset_dut();
            key = 128'h000102030405060708090a0b0c0d0e0f;
            message = 128'h101112131415161718191a1b1c1d1e1f;

            repeat (250) @(posedge clk);


            #1;



            check_outputs(128'h8bb927494f669932087595c27632906b);
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
        input [127:0] expected_hmac;
        begin
            if (expected_hmac === (expected_hmac ^ hmac ^ expected_hmac)) begin
                $display("PASS");
                $display("  Outputs: hmac=%h",
                         hmac);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hmac=%h",
                         expected_hmac);
                $display("  Got:      hmac=%h",
                         hmac);
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
        $dumpvars(0,clk, key, message, rst, hmac);
    end

endmodule
