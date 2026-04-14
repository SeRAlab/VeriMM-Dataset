`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] din_a;
    reg [3:0] din_b;
    reg [3:0] din_c;
    wire [3:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din_a(din_a),
        .din_b(din_b),
        .din_c(din_c),
        .dout(dout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %03d: Basic addition (1+2+3)", test_num);
        din_a = 4'd1; din_b = 4'd2; din_c = 4'd3;
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %03d: All zeros", test_num);
        din_a = 4'd0; din_b = 4'd0; din_c = 4'd0;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %03d: Max single input (15+0+0)", test_num);
        din_a = 4'd15; din_b = 4'd0; din_c = 4'd0;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %03d: Simple overflow (8+8+0=16)", test_num);
        din_a = 4'd8; din_b = 4'd8; din_c = 4'd0;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %03d: Resulting in 15 (5+5+5)", test_num);
        din_a = 4'd5; din_b = 4'd5; din_c = 4'd5;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %03d: Multiple overflow (10+10+10=30)", test_num);
        din_a = 4'd10; din_b = 4'd10; din_c = 4'd10;
        #1;

        check_outputs(4'd14);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %03d: Maximum sum (15+15+15=45)", test_num);
        din_a = 4'd15; din_b = 4'd15; din_c = 4'd15;
        #1;

        check_outputs(4'd13);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Running Test Case %03d: Pattern test (10+2+1=13)", test_num);
        din_a = 4'b1010; din_b = 4'b0010; din_c = 4'b0001;
        #1;

        check_outputs(4'd13);
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
        input [3:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
