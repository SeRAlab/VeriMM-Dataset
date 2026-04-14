`timescale 1ns/1ps

module chacha20_round_tb;

    // Testbench signals (combinational circuit)
    reg [255:0] key;
    reg [63:0] nonce;
    wire [255:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_round dut (
        .key(key),
        .nonce(nonce),
        .state(state)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros Input", test_num);
            key = 256'h0;
            nonce = 64'h0;


            #1;



            check_outputs(256'h0000000000000000000000000000000000000000000000000000000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Ones (Saturation)", test_num);
            key = {8{32'hFFFFFFFF}};
            nonce = 64'hFFFFFFFFFFFFFFFF;

            #1;


            check_outputs(256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Key Sequential Pattern", test_num);
            key = 256'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
            nonce = 64'h0;

            #1;


            check_outputs(256'h624581239A01BCCBAF01246789ABCDEF0123456789ABCDEF0123456789ABCDEF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Nonce Sequential Pattern", test_num);
            key = 256'h0;
            nonce = 64'hFEDCBA9876543210;

            #1;


            check_outputs(256'h000000000000000000000000000000000000000000000000FEDCBA9876543210);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits (0x55/0xAA)", test_num);
            key = {4{64'h55555555AAAAAAAA}};
            nonce = 64'hAAAAAAAAAAAAAAAA;

            #1;


            check_outputs(256'h55555555AAAAAAAA55555555AAAAAAAA55555555AAAAAAAA55555555AAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Avalanche Effect - Single Bit Flip", test_num);
            key = 256'h1;
            nonce = 64'h0;

            #1;


            check_outputs(256'h0000000000000000000000000000000000000000000000000000000000000001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_round Testbench");
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
        input [255:0] expected_state;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: state=%h",
                         state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h",
                         expected_state);
                $display("  Got:      state=%h",
                         state);
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
