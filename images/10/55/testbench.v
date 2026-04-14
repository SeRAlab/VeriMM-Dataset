`timescale 1ns/1ps

module hmac_generator_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] key;
    reg [127:0] message;
    wire [127:0] hmac;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hmac_generator dut (
        .key(key),
        .message(message),
        .hmac(hmac)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            key = 128'h0;
            message = 128'h0;

            #1;


            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Key All Ones, Message All Zeros", test_num);
            key = {4{32'hFFFFFFFF}};
            message = 128'h0;

            #1;


            check_outputs({4{32'hFFFFFFFF}});
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Key All Zeros, Message All Ones", test_num);
            key = 128'h0;
            message = {4{32'hFFFFFFFF}};

            #1;


            check_outputs({4{32'hFFFFFFFF}});
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Key All Ones, Message All Ones", test_num);
            key = {4{32'hFFFFFFFF}};
            message = {4{32'hFFFFFFFF}};

            #1;


            check_outputs(128'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits (A5/5A Pattern)", test_num);
            key = {16{8'hA5}};
            message = {16{8'h5A}};

            #1;


            check_outputs({16{8'hFF}});
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Specific Hex Pattern", test_num);
            key = 128'h123456789ABCDEF0123456789ABCDEF0;
            message = 128'hFEDCBA9876543210FEDCBA9876543210;

            #1;


            check_outputs({4{32'hFFFFFFFF}});
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random-like Values", test_num);
            key = 128'hDEADBEEFCAFEBABE0123456789ABCDEF;
            message = 128'h11111111111111111111111111111111;

            #1;


            check_outputs(128'hDEADBEEFCAFEBABE0123456789ABCDEF ^ 128'h11111111111111111111111111111111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hmac_generator Testbench");
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
        input [127:0] expected_hmac;
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
