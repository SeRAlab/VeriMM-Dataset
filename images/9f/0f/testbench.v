`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] regread0;
    reg [3:0] regread1;
    reg [3:0] regread2;
    reg [3:0] regread3;
    reg [1:0] src;
    wire [3:0] dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .regread0(regread0),
        .regread1(regread1),
        .regread2(regread2),
        .regread3(regread3),
        .src(src),
        .dataout(dataout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select regread0", test_num);
            regread0 = 4'hA;
            regread1 = 4'h5;
            regread2 = 4'hF;
            regread3 = 4'h0;
            src = 2'b00;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select regread1", test_num);
            regread0 = 4'hA;
            regread1 = 4'h5;
            regread2 = 4'hF;
            regread3 = 4'h0;
            src = 2'b01;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select regread2", test_num);
            regread0 = 4'hA;
            regread1 = 4'h5;
            regread2 = 4'hF;
            regread3 = 4'h0;
            src = 2'b10;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select regread3", test_num);
            regread0 = 4'hA;
            regread1 = 4'h5;
            regread2 = 4'hF;
            regread3 = 4'h0;
            src = 2'b11;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: All inputs same, check select", test_num);
            regread0 = 4'hC;
            regread1 = 4'hC;
            regread2 = 4'hC;
            regread3 = 4'hC;
            src = 2'b10;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Bit pattern 1100 on regread3", test_num);
            regread0 = 4'h0;
            regread1 = 4'h0;
            regread2 = 4'h0;
            regread3 = 4'b1100;
            src = 2'b11;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Data change while src fixed", test_num);
            src = 2'b01;
            regread1 = 4'h3;
            #5;
            regread1 = 4'hE;
            #1;

            check_outputs(4'hE);
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
        input [3:0] expected_dataout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout)) begin
                $display("PASS");
                $display("  Outputs: dataout=%h",
                         dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%h",
                         expected_dataout);
                $display("  Got:      dataout=%h",
                         dataout);
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
