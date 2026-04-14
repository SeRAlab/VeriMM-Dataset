`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg check_hmac;
    reg gen_hmac;
    reg [63:0] key;
    reg [511:0] msg;
    wire [255:0] hmac;
    wire hmac_ok;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .check_hmac(check_hmac),
        .gen_hmac(gen_hmac),
        .key(key),
        .msg(msg),
        .hmac(hmac),
        .hmac_ok(hmac_ok)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Generate HMAC with Key=0, Msg=0", test_num);


            key = 64'h0;
            msg = 512'h0;
            gen_hmac = 1;
            check_hmac = 0;


            #100;



            #1;




            check_outputs(256'hb6bc8f3074556434446b7a0701886326e0689b0200543e8d97587747e40a02b6, 0);


            gen_hmac = 0;
            #10;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Verify HMAC (Check Operation)", test_num);


            gen_hmac = 0;
            check_hmac = 1;

            #100;


            #1;



            check_outputs(256'hb6bc8f3074556434446b7a0701886326e0689b0200543e8d97587747e40a02b6, 1);

            check_hmac = 0;
            #10;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Generate HMAC with Pattern Key and Message", test_num);

            key = 64'h0123456789ABCDEF;
            msg = 512'h55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA55AA;
            gen_hmac = 1;
            check_hmac = 0;

            #100;


            #1;



            check_outputs(256'h7f01799201f3f609e99a38f075d985a9f5d345091e60f2249071583d739811e5, 0);

            gen_hmac = 0;
            #10;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Verify HMAC Failure (Corrupted Message)", test_num);


            key = 64'h0123456789ABCDEF;
            msg[0] = ~msg[0];

            gen_hmac = 0;
            check_hmac = 1;

            #100;


            #1;



            check_outputs(256'h7f01799201f3f609e99a38f075d985a9f5d345091e60f2249071583d739811e5, 0);

            check_hmac = 0;
            #10;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Generate HMAC with All-Ones Key/Msg", test_num);

            key = 64'hFFFFFFFFFFFFFFFF;
            msg = {16{32'hFFFFFFFF}};
            gen_hmac = 1;
            check_hmac = 0;

            #100;


            #1;



            check_outputs(255'h23e71661642846995662f556b683377755364124976472251125211242316421, 0);

            gen_hmac = 0;
            #10;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Check Idle State (No Commands)", test_num);

            gen_hmac = 0;
            check_hmac = 0;

            #50;


            if (hmac_ok === 0) begin
                $display("PASS: hmac_ok is low during idle");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: hmac_ok is high during idle");
                fail_count = fail_count + 1;
            end
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
        input [255:0] expected_hmac;
        input expected_hmac_ok;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hmac === (expected_hmac ^ hmac ^ expected_hmac) &&
                expected_hmac_ok === (expected_hmac_ok ^ hmac_ok ^ expected_hmac_ok)) begin
                $display("PASS");
                $display("  Outputs: hmac=%h, hmac_ok=%b",
                         hmac, hmac_ok);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hmac=%h, hmac_ok=%b",
                         expected_hmac, expected_hmac_ok);
                $display("  Got:      hmac=%h, hmac_ok=%b",
                         hmac, hmac_ok);
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
