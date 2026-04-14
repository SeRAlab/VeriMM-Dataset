`timescale 1ns/1ps

module bluetooth_fsm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg connect;
    reg disconnect;
    reg rst;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_fsm dut (
        .clk(clk),
        .connect(connect),
        .disconnect(disconnect),
        .rst(rst),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            connect = 0;
            disconnect = 0;
            #10;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial State after Reset", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition IDLE to CONNECTED", test_num);
            reset_dut();

            @(negedge clk);
            connect = 1;
            @(negedge clk);
            connect = 0;


            #1;



            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition IDLE to DISCONNECTED", test_num);
            reset_dut();

            @(negedge clk);
            disconnect = 1;
            @(negedge clk);
            disconnect = 0;


            #1;



            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition IDLE -> CONNECTED -> IDLE", test_num);
            reset_dut();


            @(negedge clk);
            connect = 1;
            @(negedge clk);
            connect = 0;


            @(negedge clk);
            disconnect = 1;
            @(negedge clk);
            disconnect = 0;


            #1;



            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Transition IDLE -> DISCONNECTED -> IDLE", test_num);
            reset_dut();


            @(negedge clk);
            disconnect = 1;
            @(negedge clk);
            disconnect = 0;


            @(negedge clk);
            connect = 1;
            @(negedge clk);
            connect = 0;


            #1;



            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Stay in CONNECTED on redundant connect", test_num);
            reset_dut();


            @(negedge clk);
            connect = 1;
            @(negedge clk);


            connect = 1;
            @(negedge clk);
            connect = 0;


            #1;



            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Complex transition sequence", test_num);
            reset_dut();


            @(negedge clk);
            connect = 1;
            @(negedge clk);
            connect = 0;


            @(negedge clk);
            disconnect = 1;
            @(negedge clk);
            disconnect = 0;


            @(negedge clk);
            disconnect = 1;
            @(negedge clk);
            disconnect = 0;


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
        $display("bluetooth_fsm Testbench");
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
        $dumpvars(0,clk, connect, disconnect, rst, state);
    end

endmodule
