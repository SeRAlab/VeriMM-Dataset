`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [1:0] AMT;
    reg [3:0] B;
    reg DIR;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .AMT(AMT),
        .B(B),
        .DIR(DIR),
        .S(S)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'hF; B = 4'h0; DIR = 1'b0; AMT = 2'd0;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'hF; B = 4'h0; DIR = 1'b0; AMT = 2'd1;
        #1;

        check_outputs(4'hE);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'hF; B = 4'h0; DIR = 1'b0; AMT = 2'd2;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'hF; B = 4'h0; DIR = 1'b0; AMT = 2'd3;
        #1;

        check_outputs(4'h8);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'hF; B = 4'h0; DIR = 1'b1; AMT = 2'd0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'hF; B = 4'h0; DIR = 1'b1; AMT = 2'd1;
        #1;

        check_outputs(4'h8);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'hF; B = 4'h0; DIR = 1'b1; AMT = 2'd2;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'hF; B = 4'h0; DIR = 1'b1; AMT = 2'd3;
        #1;

        check_outputs(4'hE);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'h5; B = 4'hA; DIR = 1'b0; AMT = 2'd1;
        #1;

        check_outputs(4'hB);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 4'h5; B = 4'hA; DIR = 1'b1; AMT = 2'd1;
        #1;

        check_outputs(4'hD);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        A = 4'b0001; B = 4'b1000; DIR = 1'b0; AMT = 2'd1;
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        A = 4'b1000; B = 4'b0001; DIR = 1'b1; AMT = 2'd1;
        #1;

        check_outputs(4'b0000);
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
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
