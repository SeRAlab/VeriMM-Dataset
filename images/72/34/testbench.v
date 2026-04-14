`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] In;
    wire [15:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In(In),
        .Out(Out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: In = 6'h00 (All Zeros)", test_num);
            In = 6'h00;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: In = 6'h3F (All Ones)", test_num);
            In = 6'h3F;
            #1;

            check_outputs(16'h003F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: In = 6'h2A (101010)", test_num);
            In = 6'h2A;
            #1;

            check_outputs(16'h002A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: In = 6'h15 (010101)", test_num);
            In = 6'h15;
            #1;

            check_outputs(16'h0015);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: In = 6'h01", test_num);
            In = 6'h01;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: In = 6'h20", test_num);
            In = 6'h20;
            #1;

            check_outputs(16'h0020);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: In = 6'h12", test_num);
            In = 6'h12;
            #1;

            check_outputs(16'h0012);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: In = 6'h0F", test_num);
            In = 6'h0F;
            #1;

            check_outputs(16'h000F);
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
        input [15:0] expected_Out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: Out=%h",
                         Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%h",
                         expected_Out);
                $display("  Got:      Out=%h",
                         Out);
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
