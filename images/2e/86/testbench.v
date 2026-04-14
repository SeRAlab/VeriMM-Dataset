`timescale 1ns/1ps

module robot_navigation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg move;
    reg reset;
    reg start;
    reg stop;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    robot_navigation dut (
        .clk(clk),
        .move(move),
        .reset(reset),
        .start(start),
        .stop(stop),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            stop = 0;
            move = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: IDLE to MOVING", test_num);
            reset_dut();

            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MOVING to STOP", test_num);
            reset_dut();


            start = 1;
            @(posedge clk);
            #1;
            start = 0;


            stop = 1;
            @(posedge clk);
            #1;
            stop = 0;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: STOP to MOVING", test_num);
            reset_dut();


            start = 1;
            @(posedge clk);
            #1;
            start = 0;


            stop = 1;
            @(posedge clk);
            #1;
            stop = 0;


            start = 1;
            @(posedge clk);
            #1;
            start = 0;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Stay in MOVING via move signal", test_num);
            reset_dut();


            start = 1;
            @(posedge clk);
            #1;
            start = 0;


            move = 1;
            @(posedge clk);
            #1;
            move = 0;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify Reset to IDLE", test_num);
            reset_dut();


            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority check (Stop vs Move)", test_num);
            reset_dut();


            start = 1;
            @(posedge clk);
            #1;
            start = 0;


            stop = 1;
            move = 1;
            @(posedge clk);
            #1;
            stop = 0;
            move = 0;

            #1;


            check_outputs(2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("robot_navigation Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [1:0] expected_state;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: state=%h",
                         state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h",
                         expected_state);
                $display("  Got:      state=%h",
                         state);
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
        $dumpvars(0,clk, move, reset, start, stop, state);
    end

endmodule
