`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] Y;

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
            $display("Testcase %0d: Multiplying 0 by 0", test_num);
            A = 32'h00000000;
            B = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplying 1234 by 1 (Identity)", test_num);
            A = 32'd1234;
            B = 32'd1;
            #1;

            check_outputs(32'd1234);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplying by zero", test_num);
            A = 32'hABCDEF12;
            B = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small product (15 x 10)", test_num);
            A = 32'd15;
            B = 32'd10;
            #1;

            check_outputs(32'd150);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Powers of 2 (2^10 x 2^5)", test_num);
            A = 32'h00000400;
            B = 32'h00000020;
            #1;

            check_outputs(32'h00008000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max 16-bit square (0xFFFF * 0xFFFF)", test_num);
            A = 32'h0000FFFF;
            B = 32'h0000FFFF;

            #1;


            check_outputs(32'hFFFE0001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Truncation check (2^16 * 2^16)", test_num);
            A = 32'h00010000;
            B = 32'h00010000;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit pattern test (0xAAAAAAAA * 2)", test_num);
            A = 32'hAAAAAAAA;
            B = 32'h00000002;
            #1;

            check_outputs(32'h55555554);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max 32-bit values (0xFFFFFFFF * 0xFFFFFFFF)", test_num);
            A = 32'hFFFFFFFF;
            B = 32'hFFFFFFFF;


            #1;



            check_outputs(32'h00000001);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large arbitrary multiplication", test_num);
            A = 32'h12345678;
            B = 32'h0000000D;

            #1;


            check_outputs(32'hEC8E6418);
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
