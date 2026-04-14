`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg done;
    reg receive_enable;
    reg reset;
    reg transmit_enable;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .done(done),
        .receive_enable(receive_enable),
        .reset(reset),
        .transmit_enable(transmit_enable),
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
            transmit_enable = 0;
            receive_enable = 0;
            done = 0;
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
            $display("Testcase %0d: Reset behavior", test_num);
            reset_dut();
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: IDLE to TRANSMIT transition", test_num);
            reset_dut();
            transmit_enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: IDLE to RECEIVE transition", test_num);
            reset_dut();
            receive_enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: TRANSMIT to IDLE via done", test_num);
            reset_dut();
            transmit_enable = 1;
            @(posedge clk);
            #2;
            transmit_enable = 0;
            done = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: RECEIVE to IDLE via done", test_num);
            reset_dut();
            receive_enable = 1;
            @(posedge clk);
            #2;
            receive_enable = 0;
            done = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Priority check (Transmit and Receive both enabled)", test_num);
            reset_dut();
            transmit_enable = 1;
            receive_enable = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(2'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Stay in TRANSMIT until done", test_num);
            reset_dut();
            transmit_enable = 1;
            @(posedge clk);
            #2;
            transmit_enable = 0;
            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(2'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: State isolation (TRANSMIT to RECEIVE request)", test_num);
            reset_dut();
            transmit_enable = 1;
            @(posedge clk);
            #2;
            receive_enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(2'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ethernet_mac_controller Testbench");
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
        $dumpvars(0,clk, done, receive_enable, reset, transmit_enable, state);
    end

endmodule
