`timescale 1ns/1ps

module xor_256bit_tb;

    // Testbench signals (combinational circuit)
    reg [255:0] a;
    reg [255:0] b;
    wire [255:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    xor_256bit dut (
        .a(a),
        .b(b),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: All Zeros");
            a = 256'h0;
            b = 256'h0;
            #1;

            check_outputs(256'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: All Ones XORed with All Ones");
            a = {4{64'hFFFF_FFFF_FFFF_FFFF}};
            b = {4{64'hFFFF_FFFF_FFFF_FFFF}};
            #1;

            check_outputs(256'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Identity Property (A XOR 0)");
            a = {4{64'hA5A5_A5A5_5A5A_5A5A}};
            b = 256'h0;
            #1;

            check_outputs({4{64'hA5A5_A5A5_5A5A_5A5A}});
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Complement Property (A XOR 1s)");
            a = {4{64'hAAAA_AAAA_5555_5555}};
            b = {4{64'hFFFF_FFFF_FFFF_FFFF}};
            #1;

            check_outputs({4{64'h5555_5555_AAAA_AAAA}});
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Checkerboard pattern XOR");
            a = {4{64'hAAAA_AAAA_AAAA_AAAA}};
            b = {4{64'h5555_5555_5555_5555}};
            #1;

            check_outputs({4{64'hFFFF_FFFF_FFFF_FFFF}});
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Single bit LSB");
            a = 256'h1;
            b = 256'h0;
            #1;

            check_outputs(256'h1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case 007: Single bit MSB");
            a = (256'h1 << 255);
            b = 256'h0;
            #1;

            check_outputs(256'h1 << 255);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case 008: MSB Cancellation");
            a = (256'h1 << 255) | 256'hF;
            b = (256'h1 << 255) | 256'hA;
            #1;

            check_outputs(256'h5);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case 009: Alternating 64-bit blocks");
            a = {64'hF0F0_F0F0_F0F0_F0F0, 64'h0, 64'hF0F0_F0F0_F0F0_F0F0, 64'h0};
            b = {64'h0, 64'h0F0F_0F0F_0F0F_0F0F, 64'h0, 64'h0F0F_0F0F_0F0F_0F0F};
            #1;

            check_outputs({64'hF0F0_F0F0_F0F0_F0F0, 64'h0F0F_0F0F_0F0F_0F0F, 64'hF0F0_F0F0_F0F0_F0F0, 64'h0F0F_0F0F_0F0F_0F0F});
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case 010: Random constant pattern");
            a = 256'h123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0;
            b = 256'hFEDCBA9876543210FEDCBA9876543210FEDCBA9876543210FEDCBA9876543210;
            #1;

            check_outputs(a ^ b);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("xor_256bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [255:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
