`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg enable;
    wire [7:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .enable(enable),
        .C(C)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 8'd10;
            B = 8'd25;
            enable = 1'b1;
            $display("Testcase %0d: Basic addition (10 + 25), Enable=1", test_num);
            #1;

            check_outputs(8'd35);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 8'd250;
            B = 8'd10;
            enable = 1'b1;
            $display("Testcase %0d: Overflow addition (250 + 10), Enable=1", test_num);
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 8'd50;
            B = 8'd50;
            enable = 1'b0;
            $display("Testcase %0d: Adder disabled, Enable=0", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 8'hFF;
            B = 8'h01;
            enable = 1'b1;
            $display("Testcase %0d: Boundary condition (255 + 1), Enable=1", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 8'hFF;
            B = 8'hFF;
            enable = 1'b1;
            $display("Testcase %0d: Maximum values (255 + 255), Enable=1", test_num);
            #1;

            check_outputs(8'd254);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 8'hFF;
            B = 8'hFF;
            enable = 1'b0;
            $display("Testcase %0d: Maximum values but disabled, Enable=0", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 8'hAA;
            B = 8'h55;
            enable = 1'b1;
            $display("Testcase %0d: Pattern addition (0xAA + 0x55), Enable=1", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 8'd0;
            B = 8'd0;
            enable = 1'b1;
            $display("Testcase %0d: Zero addition (0 + 0), Enable=1", test_num);
            #1;

            check_outputs(8'd0);
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
        input [7:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
