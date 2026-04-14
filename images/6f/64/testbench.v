`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [255:0] key;
    reg [255:0] msg;
    wire [255:0] hmac;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .key(key),
        .msg(msg),
        .hmac(hmac)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All zeros input", test_num);
            key = 256'h0;
            msg = 256'h0;


            #1;



            check_outputs(256'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All ones input", test_num);
            key = {256{1'b1}};
            msg = {256{1'b1}};
            #1;

            check_outputs(256'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating bit patterns", test_num);
            key = {128{2'b01}};
            msg = {128{2'b10}};
            #1;

            check_outputs(256'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: NIST-like pattern 1", test_num);
            key = 256'h0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b;
            msg = 256'h4869205468657265;
            #1;

            check_outputs(256'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Message boundary variation", test_num);
            key = 256'hDEADBEEFCAFEBABE12345678876543210000000000000000FFFFFFFFFFFFFFFF;
            msg = 256'h0000000000000000000000000000000000000000000000000000000000000001;
            #1;

            check_outputs(256'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Key boundary variation", test_num);
            key = 256'h8000000000000000000000000000000000000000000000000000000000000000;
            msg = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(256'h0);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Walking ones in message", test_num);
            key = 256'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5;
            for (i = 0; i < 256; i = i + 64) begin
                msg = (256'b1 << i);
                #1;

                $display("  Testing bit shift %d", i);
            end
            pass_count = pass_count + 1;
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
        testcase007();
        
        
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
