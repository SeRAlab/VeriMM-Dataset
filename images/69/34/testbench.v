`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [1:0] signextsignal;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .signextsignal(signextsignal),
        .y(y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Sign Extension (00) - Positive Value", test_num);
        a = 16'h7A5C;
        signextsignal = 2'b00;
        #1;

        check_outputs(32'h00007A5C);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Sign Extension (00) - Negative Value", test_num);
        a = 16'h8001;
        signextsignal = 2'b00;
        #1;

        check_outputs(32'hFFFF8001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Zero Extension (10) - Negative Value Input", test_num);
        a = 16'hF00F;
        signextsignal = 2'b10;
        #1;

        check_outputs(32'h0000F00F);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Zero Extension (10) - Positive Value Input", test_num);
        a = 16'h00FF;
        signextsignal = 2'b10;
        #1;

        check_outputs(32'h000000FF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Fill Ones (11) - Positive Value Input", test_num);
        a = 16'h1234;
        signextsignal = 2'b11;
        #1;

        check_outputs(32'hFFFF1234);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Fill Ones (11) - Negative Value Input", test_num);
        a = 16'hABCD;
        signextsignal = 2'b11;
        #1;

        check_outputs(32'hFFFFABCD);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Edge Case - All Zeros (Sign Ext)", test_num);
        a = 16'h0000;
        signextsignal = 2'b00;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Edge Case - All Ones (Zero Ext)", test_num);
        a = 16'hFFFF;
        signextsignal = 2'b10;
        #1;

        check_outputs(32'h0000FFFF);
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
        input [31:0] expected_y;
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
