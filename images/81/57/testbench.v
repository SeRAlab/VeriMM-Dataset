`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [41:0] xxx;
    reg [1:0] yyy;
    wire [41:0] zzz;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .xxx(xxx),
        .yyy(yyy),
        .zzz(zzz)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (0 + 0)", test_num);
            xxx = 42'd0;
            yyy = 2'd0;
            #1;

            check_outputs(42'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: xxx=0, yyy=3", test_num);
            xxx = 42'd0;
            yyy = 2'd3;
            #1;

            check_outputs(42'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large xxx, yyy=0", test_num);
            xxx = 42'h2AAAAAAAAAA;
            yyy = 2'd0;
            #1;

            check_outputs(42'h2AAAAAAAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple carry (1 + 1)", test_num);
            xxx = 42'd1;
            yyy = 2'd1;
            #1;

            check_outputs(42'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full carry propagation (Wrap around 0)", test_num);
            xxx = 42'h3FFFFFFFFFF;
            yyy = 2'd1;
            #1;

            check_outputs(42'h00000000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max xxx + Max yyy (Wrap around to 2)", test_num);
            xxx = 42'h3FFFFFFFFFF;
            yyy = 2'd3;
            #1;

            check_outputs(42'h00000000002);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry through lower nibbles", test_num);
            xxx = 42'h000000000FF;
            yyy = 2'd1;
            #1;

            check_outputs(42'h00000000100);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary bits", test_num);
            xxx = 42'h123456789AB;
            yyy = 2'd2;
            #1;

            check_outputs(42'h123456789AD);
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
        input [41:0] expected_zzz;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_zzz === (expected_zzz ^ zzz ^ expected_zzz)) begin
                $display("PASS");
                $display("  Outputs: zzz=%h",
                         zzz);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: zzz=%h",
                         expected_zzz);
                $display("  Got:      zzz=%h",
                         zzz);
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
