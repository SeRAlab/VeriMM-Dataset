`timescale 1ns/1ps

module pcie_endpoint_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    reg start;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_endpoint_controller dut (
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .start(start),
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
            ack = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Check IDLE state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Transition IDLE -> REQUEST", test_num);
            reset_dut();
            start = 1;
            @(posedge clk);
            #1 start = 0;

            #1;


            check_outputs(REQUEST);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Transition REQUEST -> ACK", test_num);
            reset_dut();
            start = 1;
            @(posedge clk);
            #1 start = 0;
            ack = 1;
            @(posedge clk);
            #1 ack = 0;

            #1;


            check_outputs(ACK);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Transition ACK -> IDLE (1 cycle delay)", test_num);
            reset_dut();

            start = 1; @(posedge clk); #1 start = 0;

            ack = 1; @(posedge clk); #1 ack = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Ensure REQUEST state holds while ack=0", test_num);
            reset_dut();
            start = 1;
            @(posedge clk);
            #1 start = 0;
            ack = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(REQUEST);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Ensure IDLE state holds while start=0", test_num);
            reset_dut();
            start = 0;
            ack = 1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(IDLE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_endpoint_controller Testbench");
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
        $dumpvars(0,ack, clk, reset, start, state);
    end

endmodule
