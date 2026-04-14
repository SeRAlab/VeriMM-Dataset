`timescale 1ns/1ps

module fsm_next_state_implementation_tb;

    // Testbench signals (combinational circuit)
    reg h;
    reg [1:0] t;
    wire U;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fsm_next_state_implementation dut (
        .h(h),
        .t(t),
        .U(U)
    );
    task testcase001;

        begin
            $display("Testcase 001: State A (00), h=0");
            test_num = 1;
            h = 0; t = 2'b00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: State A (00), h=1");
            test_num = 2;
            h = 1; t = 2'b00;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: State B (01), h=0");
            test_num = 3;
            h = 0; t = 2'b01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: State B (01), h=1");
            test_num = 4;
            h = 1; t = 2'b01;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: State C (10), h=0");
            test_num = 5;
            h = 0; t = 2'b10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: State C (10), h=1");
            test_num = 6;
            h = 1; t = 2'b10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: State D (11), h=0");
            test_num = 7;
            h = 0; t = 2'b11;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: State D (11), h=1");
            test_num = 8;
            h = 1; t = 2'b11;
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
        $display("fsm_next_state_implementation Testbench");
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
        input expected_U;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_U === (expected_U ^ U ^ expected_U)) begin
                $display("PASS");
                $display("  Outputs: U=%b",
                         U);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: U=%b",
                         expected_U);
                $display("  Got:      U=%b",
                         U);
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
