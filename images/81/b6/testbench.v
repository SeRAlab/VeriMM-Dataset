`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    reg [7:0] input1;
    reg [7:0] input2;
    reg [7:0] input3;
    reg [7:0] input4;
    reg sel_b1;
    reg sel_b2;
    wire [7:0] out_hi;
    wire [7:0] out_lo;
    wire [7:0] out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .input1(input1),
        .input2(input2),
        .input3(input3),
        .input4(input4),
        .sel_b1(sel_b1),
        .sel_b2(sel_b2),
        .out_hi(out_hi),
        .out_lo(out_lo),
        .out_xor(out_xor)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Input 1, Zero Shift (All 0s)", test_num);
        input1 = 8'hAA; input2 = 8'hBB; input3 = 8'hCC; input4 = 8'hDD;
        sel_b1 = 0; sel_b2 = 0;
        in = 16'h0000;





        #1;






        check_outputs(8'h00, 8'h00, 8'hAA);
    end
    endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Input 2, Maximum Shift (All 1s)", test_num);
        input1 = 8'hAA; input2 = 8'h55; input3 = 8'hCC; input4 = 8'hDD;
        sel_b1 = 1; sel_b2 = 0;
        in = 16'hFFFF;





        #1;






        check_outputs(8'h7F, 8'hFE, 8'hD4);
    end
    endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Input 3, Specific Pattern 1", test_num);
        input1 = 8'h11; input2 = 8'h22; input3 = 8'hF0; input4 = 8'h44;
        sel_b1 = 0; sel_b2 = 1;
        in = 16'h8001;





        #1;






        check_outputs(8'h40, 8'h02, 8'hB2);
    end
    endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Input 4, Specific Pattern 2", test_num);
        input1 = 8'h55; input2 = 8'h66; input3 = 8'h77; input4 = 8'h0F;
        sel_b1 = 1; sel_b2 = 1;
        in = 16'h1234;





        #1;






        check_outputs(8'h09, 8'h68, 8'h6E);
    end
    endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Input 1, Mixed Shift Pattern", test_num);
        input1 = 8'hAA; input2 = 8'hBB; input3 = 8'hCC; input4 = 8'hDD;
        sel_b1 = 0; sel_b2 = 0;
        in = 16'h55AA;





        #1;






        check_outputs(8'h2A, 8'h54, 8'hD4);
    end
    endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Input 2, Inverse Mixed Shift Pattern", test_num);
        input1 = 8'hAA; input2 = 8'hBB; input3 = 8'hCC; input4 = 8'hDD;
        sel_b1 = 1; sel_b2 = 0;
        in = 16'hA5A5;





        #1;






        check_outputs(8'h52, 8'h4A, 8'hA3);
    end
    endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Input 3, Lower Byte Shift Focus", test_num);
        input1 = 8'h01; input2 = 8'h02; input3 = 8'hCC; input4 = 8'h04;
        sel_b1 = 0; sel_b2 = 1;
        in = 16'h00FF;





        #1;






        check_outputs(8'h00, 8'hFE, 8'h32);
    end
    endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select Input 4, Upper Byte Shift Focus", test_num);
        input1 = 8'hF1; input2 = 8'hF2; input3 = 8'hF3; input4 = 8'hDD;
        sel_b1 = 1; sel_b2 = 1;
        in = 16'hFF00;





        #1;






        check_outputs(8'h7F, 8'h00, 8'hA2);
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
        input [7:0] expected_out_hi;
        input [7:0] expected_out_lo;
        input [7:0] expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_hi === (expected_out_hi ^ out_hi ^ expected_out_hi) &&
                expected_out_lo === (expected_out_lo ^ out_lo ^ expected_out_lo) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: out_hi=%h, out_lo=%h, out_xor=%h",
                         out_hi, out_lo, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_hi=%h, out_lo=%h, out_xor=%h",
                         expected_out_hi, expected_out_lo, expected_out_xor);
                $display("  Got:      out_hi=%h, out_lo=%h, out_xor=%h",
                         out_hi, out_lo, out_xor);
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
