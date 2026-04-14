`timescale 1ns/1ps

module ARQ_Controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_received;
    reg reset;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ARQ_Controller dut (
        .clk(clk),
        .data_received(data_received),
        .reset(reset),
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
            data_received = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: System Reset Initialization", test_num);
            reset_dut();

            #1;


            check_outputs(STATE_NACK);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Successful Data Reception", test_num);
            reset_dut();
            data_received = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(STATE_ACK);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Incorrect Data Reception", test_num);
            reset_dut();
            data_received = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(STATE_NACK);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Recovery from NACK to ACK", test_num);
            reset_dut();


            data_received = 0;
            @(posedge clk);


            data_received = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(STATE_ACK);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Sustained ACK State", test_num);
            reset_dut();

            data_received = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(STATE_ACK);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: ACK to NACK Transition", test_num);
            reset_dut();


            data_received = 1;
            @(posedge clk);


            data_received = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(STATE_NACK);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ARQ_Controller Testbench");
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
        $dumpvars(0,clk, data_received, reset, state);
    end

endmodule
