`timescale 1ns/1ps

module state_fsm_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] m;
    reg r;
    wire M2;
    wire M3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    state_fsm dut (
        .m(m),
        .r(r),
        .M2(M2),
        .M3(M3)
    );
    task testcase001;

    begin
        test_num = 1;

        m = 4'b0001; r = 1'b0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;

        m = 4'b0001; r = 1'b1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;

        m = 4'b0010; r = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;

        m = 4'b0010; r = 1'b1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;

        m = 4'b0100; r = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;

        m = 4'b0100; r = 1'b1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;

        m = 4'b1000; r = 1'b0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;

        m = 4'b1000; r = 1'b1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;

        m = 4'b0000; r = 1'b0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("state_fsm Testbench");
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
        input expected_M2;
        input expected_M3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_M2 === (expected_M2 ^ M2 ^ expected_M2) &&
                expected_M3 === (expected_M3 ^ M3 ^ expected_M3)) begin
                $display("PASS");
                $display("  Outputs: M2=%b, M3=%b",
                         M2, M3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: M2=%b, M3=%b",
                         expected_M2, expected_M3);
                $display("  Got:      M2=%b, M3=%b",
                         M2, M3);
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
