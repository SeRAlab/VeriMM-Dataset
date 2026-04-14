`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [127:0] ip;
    reg [127:0] ip_key;
    wire [127:0] op;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .ip(ip),
        .ip_key(ip_key),
        .op(op)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bypass Mode (enable=0)", test_num);
            enable = 1'b0;
            ip = 128'hCAFEBABE_DEADBEEF_01234567_89ABCDEF;
            ip_key = 128'hFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF;
            #1;

            check_outputs(128'hCAFEBABE_DEADBEEF_01234567_89ABCDEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: XOR Mode (enable=1) - Basic", test_num);
            enable = 1'b1;
            ip     = 128'h00000000_00000000_00000000_00000000;
            ip_key = 128'hA5A5A5A5_A5A5A5A5_A5A5A5A5_A5A5A5A5;
            #1;

            check_outputs(128'hA5A5A5A5_A5A5A5A5_A5A5A5A5_A5A5A5A5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: XOR Mode - All ones XOR All ones", test_num);
            enable = 1'b1;
            ip     = 128'hFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF;
            ip_key = 128'hFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF;
            #1;

            check_outputs(128'h00000000_00000000_00000000_00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: XOR Mode - Complementary Bits", test_num);
            enable = 1'b1;
            ip     = 128'hAAAAAAA_AAAAAAA_AAAAAAA_AAAAAAA;
            ip_key = 128'h5555555_5555555_5555555_5555555;
            #1;

            check_outputs(128'hFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bypass Mode - Key Independence", test_num);
            enable = 1'b0;
            ip     = 128'h12345678_9ABCDEF0_0FEDCBA9_87654321;
            ip_key = 128'h00000000_00000000_00000000_00000000;
            #1;
            ip_key = 128'hFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF;
            #1;

            check_outputs(128'h12345678_9ABCDEF0_0FEDCBA9_87654321);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Pattern XOR", test_num);
            enable = 1'b1;
            ip     = 128'hBD2B3E14_6329A1B2_7C30D421_938B102F;
            ip_key = 128'h4A1201D4_2210BC13_9A1203CC_A1B2C3D4;





            #1;






            check_outputs(128'hF7393FC0_41391DA1_E622D7ED_3239D3FB);
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
        input [127:0] expected_op;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_op === (expected_op ^ op ^ expected_op)) begin
                $display("PASS");
                $display("  Outputs: op=%h",
                         op);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: op=%h",
                         expected_op);
                $display("  Got:      op=%h",
                         op);
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
