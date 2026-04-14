`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift by 0 (Identity)", test_num);
            a = 32'hDEADBEEF;
            b = 32'h00000000;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift by 1", test_num);
            a = 32'h00000001;
            b = 32'h00000001;
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift by 16", test_num);
            a = 32'h12345678;
            b = 32'd16;
            #1;

            check_outputs(32'h56780000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift by 31", test_num);
            a = 32'h00000001;
            b = 32'd31;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift by 32 (Boundary - Should be 0)", test_num);
            a = 32'hFFFFFFFF;
            b = 32'd32;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift by 63 (Maximum within 6-bit range)", test_num);
            a = 32'hFFFFFFFF;
            b = 32'd63;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Ignore upper bits of b (b[31:6])", test_num);

            a = 32'h00000001;
            b = 32'h00000042;
            #1;

            check_outputs(32'h00000004);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift all ones by 4", test_num);
            a = 32'hFFFFFFFF;
            b = 32'd4;
            #1;

            check_outputs(32'hFFFFFFF0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift pattern 0xAAAAAAAA by 8", test_num);
            a = 32'hAAAAAAAA;
            b = 32'd8;
            #1;

            check_outputs(32'hAAAAAA00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex control signal b", test_num);

            a = 32'hF0F0F0F0;
            b = 32'hFFFFFFC1;
            #1;

            check_outputs(32'hE1E1E1E0);
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
        input [31:0] expected_c;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: c=%h",
                         c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h",
                         expected_c);
                $display("  Got:      c=%h",
                         c);
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
