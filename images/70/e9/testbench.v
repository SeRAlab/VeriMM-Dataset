`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    wire OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .OUT(OUT)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Positive condition via signed overflow (A=100, B=156, C=0)", test_num);




            A = 8'd100;
            B = 8'd156;
            C = 8'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Positive condition via signed overflow (A=0, B=100, C=156)", test_num);

            A = 8'd0;
            B = 8'd100;
            C = 8'd156;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Simple ascending sequence (A=10, B=20, C=30)", test_num);



            A = 8'd10;
            B = 8'd20;
            C = 8'd30;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Simple descending sequence (A=30, B=20, C=10)", test_num);



            A = 8'd30;
            B = 8'd20;
            C = 8'd10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: All coordinates zero", test_num);

            A = 8'd0;
            B = 8'd0;
            C = 8'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Max boundary overflow (A=127, B=128, C=0)", test_num);




            A = 8'd127;
            B = 8'd128;
            C = 8'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Small differences, one positive (A=1, B=2, C=1)", test_num);



            A = 8'd1;
            B = 8'd2;
            C = 8'd1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Large values, no overflow condition (A=200, B=201, C=202)", test_num);




            A = 8'd200;
            B = 8'd201;
            C = 8'd202;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Edge case near overflow (A=64, B=192, C=0)", test_num);




            A = 8'd64;
            B = 8'd192;
            C = 8'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Mixed values resulting in LOW (A=50, B=60, C=40)", test_num);
            A = 8'd50;
            B = 8'd60;
            C = 8'd40;
            #1;

            check_outputs(1'b0);
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
        input expected_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%b",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%b",
                         expected_OUT);
                $display("  Got:      OUT=%b",
                         OUT);
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
