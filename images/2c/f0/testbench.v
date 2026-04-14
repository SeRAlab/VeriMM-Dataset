`timescale 1ns/1ps

module SLAM_FSM_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg start_map;
    reg start_navigate;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SLAM_FSM dut (
        .clk(clk),
        .reset(reset),
        .start_map(start_map),
        .start_navigate(start_navigate),
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
            start_map = 0;
            start_navigate = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Verify Reset to IDLE", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Verify IDLE -> MAP transition", test_num);
            reset_dut();
            start_map = 1;
            @(posedge clk);
            #2 start_map = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Verify MAP -> NAVIGATE transition", test_num);
            reset_dut();

            start_map = 1;
            @(posedge clk);
            #2 start_map = 0;
            @(posedge clk);
            #2;

            start_navigate = 1;
            @(posedge clk);
            #2 start_navigate = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Verify NAVIGATE -> IDLE transition (via reset signal)", test_num);
            reset_dut();

            start_map = 1;
            @(posedge clk);
            #2 start_map = 0;
            @(posedge clk);
            #2 start_navigate = 1;
            @(posedge clk);
            #2 start_navigate = 0;
            @(posedge clk);
            #2;


            reset = 1;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Verify IDLE ignores start_navigate", test_num);
            reset_dut();
            start_navigate = 1;
            @(posedge clk);
            #2 start_navigate = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Verify FSM holds MAP state", test_num);
            reset_dut();
            start_map = 1;
            @(posedge clk);
            #2 start_map = 0;
            repeat(3) @(posedge clk);
            #2;

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
        $dumpvars(0,clk, reset, start_map, start_navigate, state);
    end

endmodule
