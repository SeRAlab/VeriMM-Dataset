`timescale 1ns/1ps

module elevator_controller_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg floor_reached;
    reg go_down;
    reg go_up;
    wire door_open;
    wire moving_down;
    wire moving_up;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    elevator_controller dut (
        .areset(areset),
        .clk(clk),
        .floor_reached(floor_reached),
        .go_down(go_down),
        .go_up(go_up),
        .door_open(door_open),
        .moving_down(moving_down),
        .moving_up(moving_up)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            go_up = 0;
            go_down = 0;
            floor_reached = 0;
            #20;
            areset = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Initial state check");
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Transition Idle -> Moving_Up");
            reset_dut();
            @(posedge clk);
            go_up = 1;
            @(posedge clk);
            #1;
            go_up = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Transition Moving_Up -> Idle");
            reset_dut();
            @(posedge clk);
            go_up = 1;
            @(posedge clk);
            #1;
            go_up = 0;
            floor_reached = 1;
            @(posedge clk);
            #1;
            floor_reached = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Transition Idle -> Moving_Down");
            reset_dut();
            @(posedge clk);
            go_down = 1;
            @(posedge clk);
            #1;
            go_down = 0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Transition Moving_Down -> Idle");
            reset_dut();
            @(posedge clk);
            go_down = 1;
            @(posedge clk);
            #1;
            go_down = 0;
            floor_reached = 1;
            @(posedge clk);
            #1;
            floor_reached = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Maintain Moving_Up state");
            reset_dut();
            @(posedge clk);
            go_up = 1;
            @(posedge clk);
            #1;
            go_up = 0;
            repeat (3) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Maintain Moving_Down state");
            reset_dut();
            @(posedge clk);
            go_down = 1;
            @(posedge clk);
            #1;
            go_down = 0;
            repeat (3) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("\nRunning testcase008: Asynchronous reset during operation");
            reset_dut();
            @(posedge clk);
            go_up = 1;
            @(posedge clk);
            #1;
            go_up = 0;
            #5;
            areset = 1;
            #10;
            areset = 0;
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
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
        input expected_door_open;
        input expected_moving_down;
        input expected_moving_up;
        begin
            if (expected_door_open === (expected_door_open ^ door_open ^ expected_door_open) &&
                expected_moving_down === (expected_moving_down ^ moving_down ^ expected_moving_down) &&
                expected_moving_up === (expected_moving_up ^ moving_up ^ expected_moving_up)) begin
                $display("PASS");
                $display("  Outputs: door_open=%b, moving_down=%b, moving_up=%b",
                         door_open, moving_down, moving_up);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: door_open=%b, moving_down=%b, moving_up=%b",
                         expected_door_open, expected_moving_down, expected_moving_up);
                $display("  Got:      door_open=%b, moving_down=%b, moving_up=%b",
                         door_open, moving_down, moving_up);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,areset, clk, floor_reached, go_down, go_up, door_open, moving_down, moving_up);
    end

endmodule
