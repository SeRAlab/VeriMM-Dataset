`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [29:0] u;
    wire [28:0] out_or4;
    wire [28:0] out_xor4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .u(u),
        .out_or4(out_or4),
        .out_xor4(out_xor4)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            u = 30'h00000000;
            $display("\nTestcase %0d: All Zeros", test_num);
            #1;

            check_outputs(29'h00000000, 29'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            u = 30'h3FFFFFFF;
            $display("\nTestcase %0d: All Ones", test_num);
            #1;

            check_outputs(29'h1FFFFFFF, 29'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            u = 30'h15555555;
            $display("\nTestcase %0d: Alternating 0101", test_num);
            #1;

            check_outputs(29'h1FFFFFFF, 29'h1FFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            u = 30'h2AAAAAAA;
            $display("\nTestcase %0d: Alternating 1010", test_num);
            #1;

            check_outputs(29'h1FFFFFFF, 29'h1FFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            u = 30'h12345678;
            $display("\nTestcase %0d: Hex Pattern 12345678", test_num);


            #1;



            check_outputs(29'h1B3E7F7C, 29'h1B2E7D44);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            u = 30'h00000001;
            $display("\nTestcase %0d: Single bit at u[0]", test_num);
            #1;

            check_outputs(29'h00000001, 29'h00000001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            u = 30'h20000000;
            $display("\nTestcase %0d: Single bit at u[29]", test_num);
            #1;

            check_outputs(29'h10000000, 29'h10000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            u = 30'h0000C000;
            $display("\nTestcase %0d: Neighboring bits u[15], u[14]", test_num);

            #1;


            check_outputs(29'h0000E000, 29'h0000A000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            u = 30'h3FFFFFFE;
            $display("\nTestcase %0d: All ones except u[0]", test_num);
            #1;

            check_outputs(29'h1FFFFFFF, 29'h00000001);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            u = 30'h1FFFFFFF;
            $display("\nTestcase %0d: All ones except u[29]", test_num);
            #1;

            check_outputs(29'h1FFFFFFF, 29'h10000000);
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
        input [28:0] expected_out_or4;
        input [28:0] expected_out_xor4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_or4 === (expected_out_or4 ^ out_or4 ^ expected_out_or4) &&
                expected_out_xor4 === (expected_out_xor4 ^ out_xor4 ^ expected_out_xor4)) begin
                $display("PASS");
                $display("  Outputs: out_or4=%h, out_xor4=%h",
                         out_or4, out_xor4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_or4=%h, out_xor4=%h",
                         expected_out_or4, expected_out_xor4);
                $display("  Got:      out_or4=%h, out_xor4=%h",
                         out_or4, out_xor4);
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
