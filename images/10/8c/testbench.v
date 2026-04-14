`timescale 1ns/1ps

module bluetooth_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg disconnect;
    reg reset;
    reg start_connection;
    wire state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_controller dut (
        .clk(clk),
        .disconnect(disconnect),
        .reset(reset),
        .start_connection(start_connection),
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
            start_connection = 0;
            disconnect = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Initial State after Reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Transition to Connected State", test_num);
            reset_dut();

            start_connection = 1;
            @(posedge clk);
            #1;
            start_connection = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Transition Connected -> Disconnected", test_num);
            reset_dut();


            start_connection = 1;
            @(posedge clk);
            #1;
            start_connection = 0;


            disconnect = 1;
            @(posedge clk);
            #1;
            disconnect = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Disconnect signal while already Disconnected", test_num);
            reset_dut();

            disconnect = 1;
            @(posedge clk);
            #1;
            disconnect = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Start signal while already Connected", test_num);
            reset_dut();


            start_connection = 1;
            @(posedge clk);
            #1;


            start_connection = 1;
            @(posedge clk);
            #1;
            start_connection = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Sequential State Toggling", test_num);
            reset_dut();


            start_connection = 1;
            @(posedge clk); #1;
            start_connection = 0;


            disconnect = 1;
            @(posedge clk); #1;
            disconnect = 0;


            start_connection = 1;
            @(posedge clk); #1;
            start_connection = 0;
            @(posedge clk); #1;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Simultaneous Start and Disconnect", test_num);
            reset_dut();

            start_connection = 1;
            disconnect = 1;
            @(posedge clk);
            #1;
            start_connection = 0;
            disconnect = 0;
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
        $display("bluetooth_controller Testbench");
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
        input expected_state;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: state=%b",
                         state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%b",
                         expected_state);
                $display("  Got:      state=%b",
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
        $dumpvars(0,clk, disconnect, reset, start_connection, state);
    end

endmodule
