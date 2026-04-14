`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] in1;
    reg [4:0] in2;
    reg select;
    wire [4:0] MuxOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .select(select),
        .MuxOut(MuxOut)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select in2 (select=0)", test_num);
            in1 = 5'b10101;
            in2 = 5'b01010;
            select = 1'b0;
            #1;

            check_outputs(5'b01010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select in1 (select=1)", test_num);
            in1 = 5'b10101;
            in2 = 5'b01010;
            select = 1'b1;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: All zeros check, select=0", test_num);
            in1 = 5'b11111;
            in2 = 5'b00000;
            select = 1'b0;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: All ones check, select=1", test_num);
            in1 = 5'b11111;
            in2 = 5'b00000;
            select = 1'b1;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Boundary value 0x1F, select=0", test_num);
            in1 = 5'h00;
            in2 = 5'h1F;
            select = 1'b0;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Boundary value 0x1F, select=1", test_num);
            in1 = 5'h1F;
            in2 = 5'h00;
            select = 1'b1;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Toggle select with different values", test_num);
            in1 = 5'h0E;
            in2 = 5'h11;
            select = 1'b0;
            #1;

            check_outputs(5'h11);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Toggle select with different values", test_num);
            in1 = 5'h0E;
            in2 = 5'h11;
            select = 1'b1;
            #1;

            check_outputs(5'h0E);
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
        input [4:0] expected_MuxOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_MuxOut === (expected_MuxOut ^ MuxOut ^ expected_MuxOut)) begin
                $display("PASS");
                $display("  Outputs: MuxOut=%h",
                         MuxOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: MuxOut=%h",
                         expected_MuxOut);
                $display("  Got:      MuxOut=%h",
                         MuxOut);
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
