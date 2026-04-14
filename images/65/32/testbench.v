`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 16'h0000;
            B = 16'h0000;
            $display("Testcase %0d: Zero multiplied by zero", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 16'hFFFF;
            B = 16'h0000;
            $display("Testcase %0d: Maximum value multiplied by zero", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 16'h0001;
            B = 16'hABCD;
            $display("Testcase %0d: Identity property (1 * 0xABCD)", test_num);
            #1;

            check_outputs(32'h0000ABCD);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 16'hFFFF;
            B = 16'h0001;
            $display("Testcase %0d: Identity property (0xFFFF * 1)", test_num);
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 16'hFFFF;
            B = 16'hFFFF;
            $display("Testcase %0d: Maximum 16-bit values (0xFFFF * 0xFFFF)", test_num);
            #1;

            check_outputs(32'hFFFE0001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 16'd123;
            B = 16'd456;
            $display("Testcase %0d: Small decimal integers (123 * 456)", test_num);
            #1;

            check_outputs(32'd56088);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 16'h0080;
            B = 16'h0100;
            $display("Testcase %0d: Powers of two (128 * 256)", test_num);
            #1;

            check_outputs(32'h00008000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 16'h1234;
            B = 16'h5678;
            $display("Testcase %0d: Arbitrary hex values (0x1234 * 0x5678)", test_num);
            #1;

            check_outputs(32'h06260060);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 16'h8000;
            B = 16'h0002;
            $display("Testcase %0d: Large A, small B (0x8000 * 2)", test_num);
            #1;

            check_outputs(32'h00010000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 16'hAAAA;
            B = 16'h5555;
            $display("Testcase %0d: Patterned bits (0xAAAA * 0x5555)", test_num);
            #1;

            check_outputs(32'h38E31C72);
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
