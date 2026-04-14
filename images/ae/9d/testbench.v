`timescale 1ns/1ps

module fsm_next_state_tb;

    // Testbench signals (combinational circuit)
    reg i;
    reg [1:0] t;
    wire W;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fsm_next_state dut (
        .i(i),
        .t(t),
        .W(W)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            t = 2'b00;
            i = 1'b0;
            $display("Testcase %0d: State U (00), i = 0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            t = 2'b00;
            i = 1'b1;
            $display("Testcase %0d: State U (00), i = 1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            t = 2'b01;
            i = 1'b0;
            $display("Testcase %0d: State V (01), i = 0", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            t = 2'b01;
            i = 1'b1;
            $display("Testcase %0d: State V (01), i = 1", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            t = 2'b10;
            i = 1'b0;
            $display("Testcase %0d: State W (10), i = 0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            t = 2'b10;
            i = 1'b1;
            $display("Testcase %0d: State W (10), i = 1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            t = 2'b11;
            i = 1'b0;
            $display("Testcase %0d: State X (11), i = 0", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            t = 2'b11;
            i = 1'b1;
            $display("Testcase %0d: State X (11), i = 1", test_num);
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
        $display("fsm_next_state Testbench");
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
        input expected_W;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_W === (expected_W ^ W ^ expected_W)) begin
                $display("PASS");
                $display("  Outputs: W=%b",
                         W);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: W=%b",
                         expected_W);
                $display("  Got:      W=%b",
                         W);
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
