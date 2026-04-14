`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [31:0] C;
    reg [31:0] D;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            A = 32'h00000000;
            B = 32'h00000000;
            C = 32'h00000000;
            D = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Addition", test_num);
            A = 32'h00000001;
            B = 32'h00000002;
            C = 32'h00000003;
            D = 32'h00000004;
            #1;

            check_outputs(32'h0000000A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Max Value", test_num);
            A = 32'hFFFFFFFF;
            B = 32'h00000000;
            C = 32'h00000000;
            D = 32'h00000000;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Overflow", test_num);
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            C = 32'h00000000;
            D = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Values No Overflow", test_num);
            A = 32'h10000000;
            B = 32'h20000000;
            C = 32'h30000000;
            D = 32'h00000005;
            #1;

            check_outputs(32'h60000005);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Overflow", test_num);
            A = 32'h80000000;
            B = 32'h80000000;
            C = 32'h80000000;
            D = 32'h80000000;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bit Patterns", test_num);
            A = 32'hAAAAAAAA;
            B = 32'h55555555;
            C = 32'hAAAAAAAA;
            D = 32'h55555555;


            #1;



            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Sum Overflow", test_num);
            A = 32'hFFFFFFFF;
            B = 32'hFFFFFFFF;
            C = 32'hFFFFFFFF;
            D = 32'hFFFFFFFF;


            #1;



            check_outputs(32'hFFFFFFFC);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Powers of Two", test_num);
            A = 32'h00000001;
            B = 32'h00000100;
            C = 32'h00010000;
            D = 32'h01000000;
            #1;

            check_outputs(32'h01010101);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary Values", test_num);
            A = 32'h12345678;
            B = 32'hA5A5A5A5;
            C = 32'h0000ABCD;
            D = 32'hFFFF0000;




            #1;





            check_outputs(32'hB7DA47EA);
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
        input [31:0] expected_Y;
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
