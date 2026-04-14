`timescale 1ns/1ps

module digital_lock_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg key1;
    reg key2;
    reg reset;
    reg [3:0] state;
    wire [3:0] next_state;
    wire unlocked;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    digital_lock dut (
        .clk(clk),
        .key1(key1),
        .key2(key2),
        .reset(reset),
        .state(state),
        .next_state(next_state),
        .unlocked(unlocked)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset logic", test_num);
            reset = 1;
            key1 = 0;
            key2 = 0;
            state = 4'b1000;
            #1;

            check_outputs(4'b0001, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: LOCKED to INPUT1 on key1", test_num);
            reset = 1; #10; reset = 0;
            state = 4'b0001;
            key1 = 1;
            key2 = 0;
            #1;

            check_outputs(4'b0100, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: LOCKED stays LOCKED without key1", test_num);
            reset = 1; #10; reset = 0;
            state = 4'b0001;
            key1 = 0;
            key2 = 0;
            #1;

            check_outputs(4'b0001, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: INPUT1 to INPUT2 on key2", test_num);
            reset = 1; #10; reset = 0;
            state = 4'b0100;
            key1 = 0;
            key2 = 1;
            #1;

            check_outputs(4'b1000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: INPUT2 to UNLOCKED on key1", test_num);
            reset = 1; #10; reset = 0;
            state = 4'b1000;
            key1 = 1;
            key2 = 0;
            #1;

            check_outputs(4'b0010, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Output bit 'unlocked' in UNLOCKED state", test_num);
            reset = 1; #10; reset = 0;
            state = 4'b0010;
            key1 = 0;
            key2 = 0;
            #1;

            check_outputs(4'b0010, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: INPUT1 stays in INPUT1 on key1 (wrong key)", test_num);
            reset = 1; #10; reset = 0;
            state = 4'b0100;
            key1 = 1;
            key2 = 0;
            #1;

            check_outputs(4'b0100, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("digital_lock Testbench");
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
        input [3:0] expected_next_state;
        input expected_unlocked;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_next_state === (expected_next_state ^ next_state ^ expected_next_state) &&
                expected_unlocked === (expected_unlocked ^ unlocked ^ expected_unlocked)) begin
                $display("PASS");
                $display("  Outputs: next_state=%h, unlocked=%b",
                         next_state, unlocked);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_state=%h, unlocked=%b",
                         expected_next_state, expected_unlocked);
                $display("  Got:      next_state=%h, unlocked=%b",
                         next_state, unlocked);
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
