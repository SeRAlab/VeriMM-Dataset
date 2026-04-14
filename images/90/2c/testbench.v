`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] i_data0;
    wire [15:0] o_data0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_data0(i_data0),
        .o_data0(o_data0)
    );
    task testcase001;

    begin
        test_num = 1;
        i_data0 = 4'h0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        i_data0 = 4'h1;
        #1;

        check_outputs(16'h1111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        i_data0 = 4'h2;
        #1;

        check_outputs(16'h2222);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        i_data0 = 4'h3;
        #1;

        check_outputs(16'h3333);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        i_data0 = 4'h4;
        #1;

        check_outputs(16'h4444);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        i_data0 = 4'h5;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        i_data0 = 4'h6;
        #1;

        check_outputs(16'h6666);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        i_data0 = 4'h7;
        #1;

        check_outputs(16'h7777);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        i_data0 = 4'h8;
        #1;

        check_outputs(16'h8888);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        i_data0 = 4'h9;
        #1;

        check_outputs(16'h9999);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        i_data0 = 4'hA;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        i_data0 = 4'hB;
        #1;

        check_outputs(16'hBBBB);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        i_data0 = 4'hC;
        #1;

        check_outputs(16'hCCCC);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        i_data0 = 4'hD;
        #1;

        check_outputs(16'hDDDD);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        i_data0 = 4'hE;
        #1;

        check_outputs(16'hEEEE);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        i_data0 = 4'hF;
        #1;

        check_outputs(16'hFFFF);
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
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [15:0] expected_o_data0;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_data0 === (expected_o_data0 ^ o_data0 ^ expected_o_data0)) begin
                $display("PASS");
                $display("  Outputs: o_data0=%h",
                         o_data0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_data0=%h",
                         expected_o_data0);
                $display("  Got:      o_data0=%h",
                         o_data0);
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
