`timescale 1ns/1ps

module elevator_controller_tb;

    // Testbench signals (combinational circuit)
    reg down;
    reg [2:0] state;
    reg up;
    wire [1:0] floor;
    wire [2:0] next_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    elevator_controller dut (
        .down(down),
        .state(state),
        .up(up),
        .floor(floor),
        .next_state(next_state)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Ground Floor, No Input", test_num);
        state = GROUND; up = 0; down = 0;
        #1;

        check_outputs(2'b00, GROUND);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Ground Floor, Up Pressed", test_num);
        state = GROUND; up = 1; down = 0;
        #1;

        check_outputs(2'b00, FIRST);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Ground Floor, Down Pressed (Boundary)", test_num);
        state = GROUND; up = 0; down = 1;
        #1;

        check_outputs(2'b00, GROUND);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: First Floor, No Input", test_num);
        state = FIRST; up = 0; down = 0;
        #1;

        check_outputs(2'b01, FIRST);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: First Floor, Up Pressed", test_num);
        state = FIRST; up = 1; down = 0;
        #1;

        check_outputs(2'b01, SECOND);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: First Floor, Down Pressed", test_num);
        state = FIRST; up = 0; down = 1;
        #1;

        check_outputs(2'b01, GROUND);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Second Floor, No Input", test_num);
        state = SECOND; up = 0; down = 0;
        #1;

        check_outputs(2'b10, SECOND);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Second Floor, Down Pressed", test_num);
        state = SECOND; up = 0; down = 1;
        #1;

        check_outputs(2'b10, FIRST);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Second Floor, Up Pressed (Boundary)", test_num);
        state = SECOND; up = 1; down = 0;
        #1;

        check_outputs(2'b10, SECOND);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: First Floor, Both Up and Down Pressed", test_num);
        state = FIRST; up = 1; down = 1;
        #1;

        check_outputs(2'b01, SECOND);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("elevator_controller Testbench");
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
        input [1:0] expected_floor;
        input [2:0] expected_next_state;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_floor === (expected_floor ^ floor ^ expected_floor) &&
                expected_next_state === (expected_next_state ^ next_state ^ expected_next_state)) begin
                $display("PASS");
                $display("  Outputs: floor=%h, next_state=%h",
                         floor, next_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: floor=%h, next_state=%h",
                         expected_floor, expected_next_state);
                $display("  Got:      floor=%h, next_state=%h",
                         floor, next_state);
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
