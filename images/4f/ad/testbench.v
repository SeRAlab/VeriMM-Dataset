`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] in0;
    reg [1:0] in1;
    reg [5:0] in2;
    wire [8:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .dout(dout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Simple positive calculation", test_num);
        in0 = 5'sd5;
        in1 = 2'd2;
        in2 = 6'd10;

        #1;


        check_outputs(9'h046);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Negative result calculation", test_num);
        in0 = -5'sd5;
        in1 = 2'd1;
        in2 = 6'd10;


        #1;



        check_outputs(9'h1D8);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Min signed input", test_num);
        in0 = -5'sd16;
        in1 = 2'd0;
        in2 = 6'd5;


        #1;



        check_outputs(9'h1B0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Multiplier is zero", test_num);
        in0 = -5'sd10;
        in1 = 2'd3;
        in2 = 6'd0;

        #1;


        check_outputs(9'h000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Sum is zero", test_num);
        in0 = -5'sd2;
        in1 = 2'd2;
        in2 = 6'd63;

        #1;


        check_outputs(9'h000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Maximum positive sum and multiplier (truncation check)", test_num);
        in0 = 5'sd15;
        in1 = 2'd3;
        in2 = 6'd63;



        #1;




        check_outputs(9'h06E);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Minimum signed input and maximum multiplier (truncation check)", test_num);
        in0 = -5'sd16;
        in1 = 2'd0;
        in2 = 6'd63;



        #1;




        check_outputs(9'h010);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Result is -1", test_num);
        in0 = -5'sd1;
        in1 = 2'd0;
        in2 = 6'd1;


        #1;



        check_outputs(9'h1FF);
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
        input [8:0] expected_dout;
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
