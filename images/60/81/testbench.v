`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in1;
    reg [15:0] in2;
    wire [16:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .res(res)
    );
    task testcase001;

    begin
        test_num = 1;
        in1 = 16'h0000;
        in2 = 16'h0000;
        #1;

        check_outputs(17'h00000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in1 = 16'h0001;
        in2 = 16'h0001;
        #1;

        check_outputs(17'h00002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in1 = 16'hFFFF;
        in2 = 16'h0001;
        #1;

        check_outputs(17'h10000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in1 = 16'hFFFF;
        in2 = 16'hFFFF;
        #1;

        check_outputs(17'h1FFFE);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in1 = 16'h5555;
        in2 = 16'hAAAA;
        #1;

        check_outputs(17'h0FFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in1 = 16'h1234;
        in2 = 16'h4321;
        #1;

        check_outputs(17'h05555);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in1 = 16'h8000;
        in2 = 16'h8000;
        #1;

        check_outputs(17'h10000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in1 = 16'h0F0F;
        in2 = 16'hF0F0;
        #1;

        check_outputs(17'h0FFFF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        in1 = 16'hDEAD;
        in2 = 16'hBEEF;
        #1;

        check_outputs(17'h19D9C);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        in1 = 16'h7FFF;
        in2 = 16'h0001;
        #1;

        check_outputs(17'h08000);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        in1 = 16'hA5A5;
        in2 = 16'h5A5A;
        #1;

        check_outputs(17'h0FFFF);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        in1 = 16'h00FF;
        in2 = 16'h0001;
        #1;

        check_outputs(17'h00100);
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
        testcase011();
        testcase012();
        
        
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
        input [16:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: res=%h",
                         res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res=%h",
                         expected_res);
                $display("  Got:      res=%h",
                         res);
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
