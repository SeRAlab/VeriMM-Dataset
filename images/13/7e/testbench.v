`timescale 1ns/1ps

module hmac_sha256_tb;

    // Testbench signals (combinational circuit)
    reg [255:0] key;
    reg [255:0] message;
    wire [255:0] hmac;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hmac_sha256 dut (
        .key(key),
        .message(message),
        .hmac(hmac)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Running testcase %03d: All Zeros", test_num);


            key     = 256'h0;
            message = 256'h0;
            #1;

            check_outputs(256'hb613679a0814d9ec772f95d778c35fc5ff1697c493715653c6c712144292c5ad);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running testcase %03d: Incremental Key", test_num);
            key     = 256'h0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f20;
            message = 256'h0;
            #1;

            check_outputs(256'h60e03886498875607908b88f344265551351f33f07a78a635293645e98547466);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running testcase %03d: All Ones Key", test_num);
            key     = {256{1'b1}};
            message = 256'h0;
            #1;

            check_outputs(256'hf8887469733a7638d21c05d70f3f382a39288e7d812d8a0d2f07328639556819);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running testcase %03d: All Ones Message", test_num);
            key     = 256'h0;
            message = {256{1'b1}};
            #1;

            check_outputs(256'he7672221b6a71e15e838944585c5df8765ec160897782b542038753239a2d3c5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running testcase %03d: String Inputs", test_num);

            key     = 256'h50617373776f7264000000000000000000000000000000000000000000000000;

            message = 256'h4d65737361676500000000000000000000000000000000000000000000000000;
            #1;

            check_outputs(256'h785f2425515093049da4d1efc60f25244585141b7f0f63124803932cf05e3240);
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
        input [255:0] expected_hmac;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
