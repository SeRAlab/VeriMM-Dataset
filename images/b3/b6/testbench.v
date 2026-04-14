`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in1;
    reg [15:0] in2;
    wire [15:0] out_nor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .out_nor(out_nor)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            in1 = 16'h0000;
            in2 = 16'h0000;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            in1 = 16'hFFFF;
            in2 = 16'hFFFF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Input (in1 all 1s, in2 all 0s)", test_num);
            in1 = 16'hFFFF;
            in2 = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complementary Bit Patterns", test_num);
            in1 = 16'hAAAA;
            in2 = 16'h5555;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Low Nibble vs High Nibble", test_num);
            in1 = 16'h00FF;
            in2 = 16'hFF00;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sparsely Populated Bits", test_num);
            in1 = 16'h1234;
            in2 = 16'h0000;


            #1;



            check_outputs(16'hEDCB);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overlapping Bits", test_num);
            in1 = 16'hC0C0;
            in2 = 16'h3030;

            #1;


            check_outputs(16'h0F0F);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Bits Check", test_num);
            in1 = 16'h0000;
            in2 = 16'h8001;

            #1;


            check_outputs(16'h7FFE);
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
        input [15:0] expected_out_nor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_nor === (expected_out_nor ^ out_nor ^ expected_out_nor)) begin
                $display("PASS");
                $display("  Outputs: out_nor=%h",
                         out_nor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_nor=%h",
                         expected_out_nor);
                $display("  Got:      out_nor=%h",
                         out_nor);
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
