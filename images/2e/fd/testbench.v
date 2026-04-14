`timescale 1ns/1ps

module ethernet_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg start_tx;
    reg tx_done;
    wire [1:0] current_state;
    wire tx_active;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ethernet_mac_controller dut (
        .clk(clk),
        .reset(reset),
        .start_tx(start_tx),
        .tx_done(tx_done),
        .current_state(current_state),
        .tx_active(tx_active)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start_tx = 0;
            tx_done = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Check IDLE state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Transition IDLE -> TRANSMIT", test_num);
            reset_dut();
            @(posedge clk);
            start_tx = 1;
            @(posedge clk);
            #1 start_tx = 0;

            #1;


            check_outputs(2'b01, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Transition TRANSMIT -> WAIT", test_num);
            reset_dut();
            @(posedge clk);
            start_tx = 1;
            @(posedge clk);
            start_tx = 0;
            tx_done = 1;
            @(posedge clk);
            #1 tx_done = 0;

            #1;


            check_outputs(2'b10, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Complete State Cycle back to IDLE", test_num);
            reset_dut();

            @(posedge clk) start_tx = 1;

            @(posedge clk) begin
                start_tx = 0;
                tx_done = 1;
            end

            @(posedge clk) tx_done = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Ignore tx_done in IDLE state", test_num);
            reset_dut();
            @(posedge clk);
            tx_done = 1;
            @(posedge clk);
            #1 tx_done = 0;

            #1;


            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verify tx_active stability in TRANSMIT", test_num);
            reset_dut();
            @(posedge clk) start_tx = 1;
            @(posedge clk) start_tx = 0;

            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(2'b01, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Reset during TRANSMIT state", test_num);
            reset_dut();
            @(posedge clk) start_tx = 1;
            @(posedge clk) start_tx = 0;
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00, 1'b0);
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
        input expected_tx_active;
        begin
            if (expected_current_state === (expected_current_state ^ current_state ^ expected_current_state) &&
                expected_tx_active === (expected_tx_active ^ tx_active ^ expected_tx_active)) begin
                $display("PASS");
                $display("  Outputs: current_state=%h, tx_active=%b",
                         current_state, tx_active);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_state=%h, tx_active=%b",
                         expected_current_state, expected_tx_active);
                $display("  Got:      current_state=%h, tx_active=%b",
                         current_state, tx_active);
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
        $dumpvars(0,clk, reset, start_tx, tx_done, current_state, tx_active);
    end

endmodule
