`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] B;
    wire [1:0] LZ;
    wire [3:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B(B),
        .LZ(LZ),
        .R(R)
    );
    task testcase001;

    begin
        test_num = 1;
        B = 4'b0000;

        #1;


        check_outputs(2'd3, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        B = 4'b0001;

        #1;


        check_outputs(2'd0, 4'b1000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        B = 4'b0010;

        #1;


        check_outputs(2'd1, 4'b0100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        B = 4'b0100;

        #1;


        check_outputs(2'd2, 4'b0010);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        B = 4'b1000;

        #1;


        check_outputs(2'd3, 4'b0001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        B = 4'b1111;

        #1;


        check_outputs(2'd0, 4'b1111);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        B = 4'b1010;

        #1;


        check_outputs(2'd1, 4'b0101);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        B = 4'b1100;

        #1;


        check_outputs(2'd2, 4'b0011);
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
        input [1:0] expected_LZ;
        input [3:0] expected_R;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_LZ === (expected_LZ ^ LZ ^ expected_LZ) &&
                expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: LZ=%h, R=%h",
                         LZ, R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LZ=%h, R=%h",
                         expected_LZ, expected_R);
                $display("  Got:      LZ=%h, R=%h",
                         LZ, R);
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
