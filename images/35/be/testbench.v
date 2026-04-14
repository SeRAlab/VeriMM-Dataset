`timescale 1ns/1ps

module dwt_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] sample;
    wire [3:0] approximation;
    wire [3:0] detail;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dwt_4bit dut (
        .sample(sample),
        .approximation(approximation),
        .detail(detail)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Zero Input", test_num);
            sample = 4'b0000;

            #1;


            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Input (15)", test_num);
            sample = 4'b1111;


            #1;



            check_outputs(4'h7, 4'h7);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Even Value (8)", test_num);
            sample = 4'b1000;

            #1;


            check_outputs(4'h4, 4'h4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Smallest Input (1)", test_num);
            sample = 4'b0001;

            #1;


            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits (10)", test_num);
            sample = 4'b1010;

            #1;


            check_outputs(4'h5, 4'h5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Odd Value (5)", test_num);
            sample = 4'b0101;

            #1;


            check_outputs(4'h2, 4'h2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: MSB Set (8)", test_num);
            sample = 4'b1000;
            #1;

            check_outputs(4'h4, 4'h4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dwt_4bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_approximation;
        input [3:0] expected_detail;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_approximation === (expected_approximation ^ approximation ^ expected_approximation) &&
                expected_detail === (expected_detail ^ detail ^ expected_detail)) begin
                $display("PASS");
                $display("  Outputs: approximation=%h, detail=%h",
                         approximation, detail);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: approximation=%h, detail=%h",
                         expected_approximation, expected_detail);
                $display("  Got:      approximation=%h, detail=%h",
                         approximation, detail);
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
