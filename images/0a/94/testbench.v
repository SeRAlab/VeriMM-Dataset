`timescale 1ns/1ps

module SLAM_FSM_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg map_done;
    reg reset;
    reg start;
    wire [1:0] current_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SLAM_FSM dut (
        .clk(clk),
        .map_done(map_done),
        .reset(reset),
        .start(start),
        .current_state(current_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            start = 0;
            map_done = 0;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Power-on Reset to IDLE", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: IDLE -> MAPPING transition", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            #1;



            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: IDLE -> MAPPING -> LOCALIZING sequence", test_num);
            reset_dut();


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            @(posedge clk);
            map_done = 1;
            @(posedge clk);
            map_done = 0;


            #1;



            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset from MAPPING back to ID", test_num);
            reset_dut();


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;


            #1;



            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset from LOCALIZING back to IDLE", test_num);
            reset_dut();


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            @(posedge clk);
            map_done = 1;
            @(posedge clk);
            map_done = 0;


            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;


            #1;



            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Stay in IDLE (No start signal)", test_num);
            reset_dut();

            repeat(3) @(posedge clk);


            #1;



            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Stay in MAPPING (No map_done signal)", test_num);
            reset_dut();


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            repeat(3) @(posedge clk);


            #1;



            check_outputs(2'b01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SLAM_FSM Testbench");
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
        input [1:0] expected_current_state;
        begin
            if (expected_current_state === (expected_current_state ^ current_state ^ expected_current_state)) begin
                $display("PASS");
                $display("  Outputs: current_state=%h",
                         current_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_state=%h",
                         expected_current_state);
                $display("  Got:      current_state=%h",
                         current_state);
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
        $dumpvars(0,clk, map_done, reset, start, current_state);
    end

endmodule
