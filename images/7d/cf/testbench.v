`timescale 1ns/1ps

module elevator_door_controller_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg close_door;
    reg open_door;
    wire door_open;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    elevator_door_controller dut (
        .areset(areset),
        .clk(clk),
        .close_door(close_door),
        .open_door(open_door),
        .door_open(door_open)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            open_door = 0;
            close_door = 0;
            #12;
            areset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify Reset State (Door_Closed)", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition Door_Closed -> Door_Open", test_num);
            reset_dut();
            @(posedge clk);
            open_door = 1;
            @(posedge clk);
            open_door = 0;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition Door_Open -> Door_Closed", test_num);
            reset_dut();

            @(posedge clk);
            open_door = 1;
            @(posedge clk);
            open_door = 0;

            close_door = 1;
            @(posedge clk);
            close_door = 0;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Stay in Door_Closed state", test_num);
            reset_dut();
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Stay in Door_Open state", test_num);
            reset_dut();
            @(posedge clk);
            open_door = 1;
            @(posedge clk);
            open_door = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Door_Closed ignores close_door", test_num);
            reset_dut();
            @(posedge clk);
            close_door = 1;
            @(posedge clk);
            close_door = 0;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simultaneous open/close in Closed state", test_num);
            reset_dut();
            @(posedge clk);
            open_door = 1;
            close_door = 1;
            @(posedge clk);
            open_door = 0;
            close_door = 0;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simultaneous open/close in Open state", test_num);
            reset_dut();

            @(posedge clk);
            open_door = 1;
            @(posedge clk);
            open_door = 0;

            @(posedge clk);
            open_door = 1;
            close_door = 1;
            @(posedge clk);
            #1;
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
        $display("elevator_door_controller Testbench");
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
        begin
            if (expected_door_open === (expected_door_open ^ door_open ^ expected_door_open)) begin
                $display("PASS");
                $display("  Outputs: door_open=%b",
                         door_open);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: door_open=%b",
                         expected_door_open);
                $display("  Got:      door_open=%b",
                         door_open);
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
        $dumpvars(0,areset, clk, close_door, open_door, door_open);
    end

endmodule
