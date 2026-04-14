`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] I;
    wire EN;
    wire [2:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I(I),
        .EN(EN),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs zero", test_num);
        I = 8'b0000_0000;
        #1;

        check_outputs(1'b1, 3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bit 0 set", test_num);
        I = 8'b0000_0001;
        #1;

        check_outputs(1'b0, 3'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bit 7 set", test_num);
        I = 8'b1000_0000;
        #1;

        check_outputs(1'b0, 3'd7);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bit 4 set", test_num);
        I = 8'b0001_0000;
        #1;

        check_outputs(1'b0, 3'd4);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bits 0 and 7 set (Priority 0)", test_num);
        I = 8'b1000_0001;
        #1;

        check_outputs(1'b0, 3'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bits 2 and 3 set (Priority 2)", test_num);
        I = 8'b0000_1100;
        #1;

        check_outputs(1'b0, 3'd2);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bits 5 and 6 set (Priority 5)", test_num);
        I = 8'b0110_0000;
        #1;

        check_outputs(1'b0, 3'd5);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bits 1, 4, 6 set (Priority 1)", test_num);
        I = 8'b0101_0010;
        #1;

        check_outputs(1'b0, 3'd1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All bits set (Priority 0)", test_num);
        I = 8'b1111_1111;
        #1;

        check_outputs(1'b0, 3'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating bits 1, 3, 5, 7 set (Priority 1)", test_num);
        I = 8'b1010_1010;
        #1;

        check_outputs(1'b0, 3'd1);
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
        input expected_EN;
        input [2:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EN === (expected_EN ^ EN ^ expected_EN) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: EN=%b, Y=%h",
                         EN, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EN=%b, Y=%h",
                         expected_EN, expected_Y);
                $display("  Got:      EN=%b, Y=%h",
                         EN, Y);
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
