`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] In0;
    reg [15:0] In1;
    reg In2;
    wire [23:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In0(In0),
        .In1(In1),
        .In2(In2),
        .dout(dout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            In0 = 7'h00;
            In1 = 16'h0000;
            In2 = 1'b0;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones", test_num);
            In0 = 7'h7F;
            In1 = 16'hFFFF;
            In2 = 1'b1;
            #1;

            check_outputs(24'hFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits (Pattern A)", test_num);




            In0 = 7'h55;
            In1 = 16'hAAAA;
            In2 = 1'b1;
            #1;

            check_outputs(24'hAB5555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary Values (Pattern B)", test_num);




            In0 = 7'h0A;
            In1 = 16'h00FF;
            In2 = 1'b0;
            #1;

            check_outputs(24'h1401FE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: MSB/LSB Toggle", test_num);




            In0 = 7'h40;
            In1 = 16'h8000;
            In2 = 1'b1;
            #1;

            check_outputs(24'h810001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random Pattern", test_num);




            In0 = 7'h39;
            In1 = 16'hCCCC;
            In2 = 1'b0;
            #1;

            check_outputs(24'h739998);
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
        input [23:0] expected_dout;
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
