`timescale 1ns/1ps

module mpc_controller_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] current_state;
    reg [7:0] target_state;
    wire [7:0] next_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mpc_controller dut (
        .current_state(current_state),
        .target_state(target_state),
        .next_state(next_state)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Equilibrium state (Current == Target)", test_num);
        current_state = 8'd100;
        target_state = 8'd100;

        #1;


        check_outputs(8'd100);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simple increase towards target", test_num);
        current_state = 8'd10;
        target_state = 8'd30;

        #1;


        check_outputs(8'd20);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simple decrease towards target", test_num);
        current_state = 8'd100;
        target_state = 8'd50;

        #1;


        check_outputs(8'd75);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Step from zero to high value", test_num);
        current_state = 8'd0;
        target_state = 8'd200;

        #1;


        check_outputs(8'd100);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Step from high value to zero", test_num);
        current_state = 8'd200;
        target_state = 8'd0;

        #1;


        check_outputs(8'd100);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum range transition", test_num);
        current_state = 8'd0;
        target_state = 8'd254;

        #1;


        check_outputs(8'd127);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Smallest possible step (truncation check)", test_num);
        current_state = 8'd10;
        target_state = 8'd11;

        #1;


        check_outputs(8'd10);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Smallest possible negative step", test_num);
        current_state = 8'd11;
        target_state = 8'd9;

        #1;


        check_outputs(8'd10);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mpc_controller Testbench");
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
        input [7:0] expected_next_state;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_next_state === (expected_next_state ^ next_state ^ expected_next_state)) begin
                $display("PASS");
                $display("  Outputs: next_state=%h",
                         next_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_state=%h",
                         expected_next_state);
                $display("  Got:      next_state=%h",
                         next_state);
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
