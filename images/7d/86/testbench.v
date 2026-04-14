`timescale 1ns/1ps

module conditional_logic_tb;

    // Testbench signals (combinational circuit)
    reg x;
    reg y;
    reg z;
    wire v_pos;
    wire v_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    conditional_logic dut (
        .x(x),
        .y(y),
        .z(z),
        .v_pos(v_pos),
        .v_sop(v_sop)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 1: Input (x,y,z) = 000 (Value 0)");
        x = 0; y = 0; z = 0;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 2: Input (x,y,z) = 001 (Value 1)");
        x = 0; y = 0; z = 1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 3: Input (x,y,z) = 010 (Value 2)");
        x = 0; y = 1; z = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 4: Input (x,y,z) = 011 (Value 3)");
        x = 0; y = 1; z = 1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 5: Input (x,y,z) = 100 (Value 4)");
        x = 1; y = 0; z = 0;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 6: Input (x,y,z) = 101 (Value 5)");
        x = 1; y = 0; z = 1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 7: Input (x,y,z) = 110 (Value 6)");
        x = 1; y = 1; z = 0;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 8: Input (x,y,z) = 111 (Value 7)");
        x = 1; y = 1; z = 1;
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
        $display("conditional_logic Testbench");
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
        input expected_v_pos;
        input expected_v_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_v_pos === (expected_v_pos ^ v_pos ^ expected_v_pos) &&
                expected_v_sop === (expected_v_sop ^ v_sop ^ expected_v_sop)) begin
                $display("PASS");
                $display("  Outputs: v_pos=%b, v_sop=%b",
                         v_pos, v_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: v_pos=%b, v_sop=%b",
                         expected_v_pos, expected_v_sop);
                $display("  Got:      v_pos=%b, v_sop=%b",
                         v_pos, v_sop);
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
