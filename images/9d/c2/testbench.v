`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [511:0] message;
    wire [127:0] hash;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .message(message),
        .hash(hash)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Message All Zeros (512-bit raw message)");
            message = 512'h0;

            #1;


            check_outputs(128'h3671415494f114c02931e5f83e206037);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Message All 'a's (512-bit raw message)");
            message = {64{8'h61}};

            #1;


            check_outputs(128'h2e987f43328d4ad74023c03348165034);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Message All Ones (512-bit raw message)");
            message = {64{8'hFF}};

            #1;


            check_outputs(128'he65985065c71701962973163359d997d);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Mixed Pattern (32 bytes AB, 32 bytes CD)");
            message = {{32{8'hAB}}, {32{8'hCD}}};

            #1;


            check_outputs(128'h6908a8e3f429665f80f19c8d50694119);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case 005: Incremental Byte Pattern (0x00 to 0x3F)");
            for (i = 0; i < 64; i = i + 1) begin
                message[((63-i)*8) +: 8] = i[7:0];
            end

            #1;


            check_outputs(128'h4f7678518e873523778553f1912534f3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: 'The quick brown fox jumps over the lazy dog' + Null Padding");

            message = {344'h54686520717569636b2062726f776e20666f78206a756d7073206f76657220746865206c617a7920646f67, 168'h0};
            #1;

            check_outputs(128'h2688f15d18588506169970c0f9979d55);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case 007: Alternating Bit Pattern (512-bit 0xAA...)");
            message = {64{8'hAA}};
            #1;

            check_outputs(128'h26529329007e296837424268e647c728);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case 008: Alternating Bit Pattern (512-bit 0x55...)");
            message = {64{8'h55}};
            #1;

            check_outputs(128'hf09002956277983652150893325e6878);
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
        testcase008();
        
        
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
        input [127:0] expected_hash;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hash === (expected_hash ^ hash ^ expected_hash)) begin
                $display("PASS");
                $display("  Outputs: hash=%h",
                         hash);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash=%h",
                         expected_hash);
                $display("  Got:      hash=%h",
                         hash);
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
