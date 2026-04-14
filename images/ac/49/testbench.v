`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [7:0] PRODUCT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .PRODUCT(PRODUCT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 4'd2; B = 4'd3;
            #1;

            check_outputs(8'd6);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'd3; B = 4'sb1110;
            #1;

            check_outputs(8'sb1111_1010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'sb1101; B = 4'd4;
            #1;

            check_outputs(8'sb1111_0100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'sb1110; B = 4'sb1101;
            #1;

            check_outputs(8'd6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'd0; B = 4'sb1000;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'd7; B = 4'd7;
            #1;

            check_outputs(8'd49);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'sb1000; B = 4'd7;
            #1;

            check_outputs(8'sb1100_1000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 4'sb1000; B = 4'sb1000;
            #1;

            check_outputs(8'sb0100_0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 4'd1; B = 4'sb1011;
            #1;

            check_outputs(8'sb1111_1011);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 4'sb1111; B = 4'd5;
            #1;

            check_outputs(8'sb1111_1011);
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
        input [7:0] expected_PRODUCT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PRODUCT === (expected_PRODUCT ^ PRODUCT ^ expected_PRODUCT)) begin
                $display("PASS");
                $display("  Outputs: PRODUCT=%h",
                         PRODUCT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PRODUCT=%h",
                         expected_PRODUCT);
                $display("  Got:      PRODUCT=%h",
                         PRODUCT);
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
