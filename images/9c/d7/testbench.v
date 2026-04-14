`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire [63:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 32'd10;
            B = 32'd20;
            #1;

            check_outputs(64'd200);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = -32'd5;
            B = -32'd10;
            #1;

            check_outputs(64'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 32'd15;
            B = -32'd4;

            #1;


            check_outputs(-64'd60);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = -32'd100;
            B = 32'd3;

            #1;


            check_outputs(-64'd300);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 32'd0;
            B = 32'd500;
            #1;

            check_outputs(64'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 32'h00010000;
            B = 32'h00010000;

            #1;


            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 32'hFFFF0000;
            B = 32'hFFFF0000;

            #1;


            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 32'h7FFFFFFF;
            B = -32'd2;


            #1;



            check_outputs(64'hFFFFFFFF00000002);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 32'h80000000;
            B = 32'h00000001;
            #1;

            check_outputs(64'hFFFFFFFF80000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 32'hFFFFFFFF;
            B = 32'hFFFFFFFF;

            #1;


            check_outputs(64'h0000000000000001);
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
        input [63:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
