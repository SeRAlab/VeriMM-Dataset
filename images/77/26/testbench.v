`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [63:0] in;
    wire [63:0] out;
    wire shiftedOff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .in(in),
        .out(out),
        .shiftedOff(shiftedOff)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive number, Enable High", test_num);
            in = 64'h7000_0000_0000_0007;
            enable = 1'b1;



            #1;




            check_outputs(64'h3800_0000_0000_0003, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative number, Enable High (Sign extension check)", test_num);
            in = 64'h8000_0000_0000_0000;
            enable = 1'b1;



            #1;




            check_outputs(64'hC000_0000_0000_0000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable Low (Bypass mode)", test_num);
            in = 64'hFEDC_BA98_7654_3210;
            enable = 1'b0;

            #1;


            check_outputs(64'hFEDC_BA98_7654_3210, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones, Enable High", test_num);
            in = 64'hFFFF_FFFF_FFFF_FFFF;
            enable = 1'b1;



            #1;




            check_outputs(64'hFFFF_FFFF_FFFF_FFFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros, Enable High", test_num);
            in = 64'h0000_0000_0000_0000;
            enable = 1'b1;

            #1;


            check_outputs(64'h0000_0000_0000_0000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Patterned input, Enable High", test_num);
            in = 64'hA5A5_A5A5_A5A5_A5A5;
            enable = 1'b1;




            #1;





            check_outputs(64'hD2D2_D2D2_D2D2_D2D2, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit at LSB, Enable High", test_num);
            in = 64'h0000_0000_0000_0001;
            enable = 1'b1;

            #1;


            check_outputs(64'h0000_0000_0000_0000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Positive value, Enable High", test_num);
            in = 64'h4000_0000_0000_0000;
            enable = 1'b1;

            #1;


            check_outputs(64'h2000_0000_0000_0000, 1'b0);
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
        input [63:0] expected_out;
        input expected_shiftedOff;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_shiftedOff === (expected_shiftedOff ^ shiftedOff ^ expected_shiftedOff)) begin
                $display("PASS");
                $display("  Outputs: out=%h, shiftedOff=%b",
                         out, shiftedOff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, shiftedOff=%b",
                         expected_out, expected_shiftedOff);
                $display("  Got:      out=%h, shiftedOff=%b",
                         out, shiftedOff);
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
