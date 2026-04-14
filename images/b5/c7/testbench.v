`timescale 1ns/1ps

module comp_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire is_equal;
    wire is_greater;
    wire is_less;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comp_32bit dut (
        .A(A),
        .B(B),
        .is_equal(is_equal),
        .is_greater(is_greater),
        .is_less(is_less)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A = 0, B = 0 (Equality check)", test_num);
            A = 32'h00000000;
            B = 32'h00000000;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A = Max, B = Max (Equality check)", test_num);
            A = 32'hFFFFFFFF;
            B = 32'hFFFFFFFF;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A = 10, B = 5 (Greater check)", test_num);
            A = 32'd10;
            B = 32'd5;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A = 5, B = 10 (Less check)", test_num);
            A = 32'd5;
            B = 32'd10;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A = 0x80000000, B = 0x7FFFFFFF (Greater check)", test_num);
            A = 32'h80000000;
            B = 32'h7FFFFFFF;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A = 0x7FFFFFFF, B = 0x80000000 (Less check)", test_num);
            A = 32'h7FFFFFFF;
            B = 32'h80000000;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A = 1, B = 0 (LSB Greater check)", test_num);
            A = 32'h00000001;
            B = 32'h00000000;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A = 0xAAAAAAAA, B = 0xAAAAAAAA (Equality check)", test_num);
            A = 32'hAAAAAAAA;
            B = 32'hAAAAAAAA;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Middle bit difference check", test_num);
            A = 32'h00010000;
            B = 32'h00020000;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A = Max, B = 0 (Extreme Greater)", test_num);
            A = 32'hFFFFFFFF;
            B = 32'h00000000;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("comp_32bit Testbench");
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
        input expected_is_equal;
        input expected_is_greater;
        input expected_is_less;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_is_equal === (expected_is_equal ^ is_equal ^ expected_is_equal) &&
                expected_is_greater === (expected_is_greater ^ is_greater ^ expected_is_greater) &&
                expected_is_less === (expected_is_less ^ is_less ^ expected_is_less)) begin
                $display("PASS");
                $display("  Outputs: is_equal=%b, is_greater=%b, is_less=%b",
                         is_equal, is_greater, is_less);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_equal=%b, is_greater=%b, is_less=%b",
                         expected_is_equal, expected_is_greater, expected_is_less);
                $display("  Got:      is_equal=%b, is_greater=%b, is_less=%b",
                         is_equal, is_greater, is_less);
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
