`timescale 1ns/1ps

module bw_u1_aoi22_8x_tb;

    // Testbench signals (combinational circuit)
    reg a1;
    reg a2;
    reg b1;
    reg b2;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bw_u1_aoi22_8x dut (
        .a1(a1),
        .a2(a2),
        .b1(b1),
        .b2(b2),
        .z(z)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All inputs zero", test_num);
        a1 = 1'b0; a2 = 1'b0; b1 = 1'b0; b2 = 1'b0;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: A side high, B side low", test_num);
        a1 = 1'b1; a2 = 1'b1; b1 = 1'b0; b2 = 1'b0;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: A side low, B side high", test_num);
        a1 = 1'b0; a2 = 1'b0; b1 = 1'b1; b2 = 1'b1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: All inputs high", test_num);
        a1 = 1'b1; a2 = 1'b1; b1 = 1'b1; b2 = 1'b1;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Partial inputs (A1, B1 high)", test_num);
        a1 = 1'b1; a2 = 1'b0; b1 = 1'b1; b2 = 1'b0;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Partial inputs (A2, B2 high)", test_num);
        a1 = 1'b0; a2 = 1'b1; b1 = 1'b0; b2 = 1'b1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Cross partial (A1, B2 high)", test_num);
        a1 = 1'b1; a2 = 1'b0; b1 = 1'b0; b2 = 1'b1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: One side fully high, one input high on other", test_num);
        a1 = 1'b1; a2 = 1'b1; b1 = 1'b1; b2 = 1'b0;

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
        $display("bw_u1_aoi22_8x Testbench");
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
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: z=%b",
                         z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z=%b",
                         expected_z);
                $display("  Got:      z=%b",
                         z);
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
