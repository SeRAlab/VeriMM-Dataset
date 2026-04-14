`timescale 1ns/1ps

module encoder_16_to_4_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] I;
    wire [3:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    encoder_16_to_4 dut (
        .I(I),
        .O(O)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: No inputs active", test_num);
            I = 16'h0000;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input line I[0] active", test_num);
            I = 16'h0001;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input line I[1] active", test_num);
            I = 16'h0002;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input line I[7] active", test_num);
            I = 16'h0080;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input line I[10] active", test_num);
            I = 16'h0400;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input line I[15] active", test_num);
            I = 16'h8000;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple active (I[0] and I[1]) - Priority check", test_num);
            I = 16'h0003;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple active (I[15] and I[0]) - Priority check", test_num);
            I = 16'h8001;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Cluster of bits (I[8], I[5], I[2]) - Priority check", test_num);
            I = 16'h0124;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All input lines active", test_num);
            I = 16'hFFFF;
            #1;

            check_outputs(4'hF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("encoder_16_to_4 Testbench");
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
        input [3:0] expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%h",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h",
                         expected_O);
                $display("  Got:      O=%h",
                         O);
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
