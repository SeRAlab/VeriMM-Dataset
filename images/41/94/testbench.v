`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] s;
    reg [7:0] t;
    wire [7:0] u;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .s(s),
        .t(t),
        .u(u)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros (s=00, t=00)", test_num);
        s = 8'h00;
        t = 8'h00;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones (s=FF, t=FF)", test_num);
        s = 8'hFF;
        t = 8'hFF;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Complementary patterns (s=AA, t=55)", test_num);
        s = 8'hAA;
        t = 8'h55;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Nibble mask (s=F0, t=00)", test_num);
        s = 8'hF0;
        t = 8'h00;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Inverse Nibble mask (s=00, t=0F)", test_num);
        s = 8'h00;
        t = 8'h0F;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Arbitrary bits (s=12, t=48)", test_num);
        s = 8'h12;
        t = 8'h48;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Overlapping bits (s=C3, t=81)", test_num);
        s = 8'hC3;
        t = 8'h81;
        #1;

        check_outputs(8'h3C);
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
        input [7:0] expected_u;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_u === (expected_u ^ u ^ expected_u)) begin
                $display("PASS");
                $display("  Outputs: u=%h",
                         u);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: u=%h",
                         expected_u);
                $display("  Got:      u=%h",
                         u);
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
