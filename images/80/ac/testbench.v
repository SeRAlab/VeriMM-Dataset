`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [255:0] hmac;
    reg [255:0] key;
    reg [255:0] message;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .hmac(hmac),
        .key(key),
        .message(message),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All-zero inputs with correct HMAC", test_num);
            message = 256'h0;
            key     = 256'h0;

            hmac    = 256'hb613679a0814d9ec772f95d778c35fc5ff1697c493715653c6c712144292c5ad;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All-zero inputs with incorrect HMAC (mismatch)", test_num);
            message = 256'h0;
            key     = 256'h0;
            hmac    = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Specified message and key with matching HMAC", test_num);
            message = 256'hABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789;
            key     = 256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;

            hmac    = 256'h4f923b361665a953e34b971a938c92a68832a88439b8c2a3847291a1338a12e1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Valid key/HMAC but message bit flipped (should fail)", test_num);

            message = 256'hABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456788;
            key     = 256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
            hmac    = 256'h4f923b361665a953e34b971a938c92a68832a88439b8c2a3847291a1338a12e1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Valid message/HMAC but key bit flipped (should fail)", test_num);
            message = 256'hABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789;

            key     = 256'h1123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
            hmac    = 256'h4f923b361665a953e34b971a938c92a68832a88439b8c2a3847291a1338a12e1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones message/key", test_num);
            message = {256{1'b1}};
            key     = {256{1'b1}};

            hmac    = 256'h9b73461239847120349817234981273498127349812734981273498127349812;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
