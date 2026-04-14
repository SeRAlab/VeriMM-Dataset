`timescale 1ns/1ps

module eth_mac_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack_received;
    reg clk;
    reg rst_n;
    reg start_tx;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eth_mac_controller dut (
        .ack_received(ack_received),
        .clk(clk),
        .rst_n(rst_n),
        .start_tx(start_tx),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            start_tx = 0;
            ack_received = 0;
            #20;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Power-on reset to IDLE state", test_num);
            reset_dut();
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Transition IDLE -> TRANSMIT", test_num);
            reset_dut();
            @(posedge clk);
            start_tx <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full Transmission Flow (IDLE -> TRANSMIT -> WAIT_FOR_ACK -> IDLE)", test_num);
            reset_dut();

            @(posedge clk);
            start_tx <= 1;
            @(posedge clk);
            start_tx <= 0;
            @(posedge clk);
            ack_received <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Stay in WAIT_FOR_ACK state", test_num);
            reset_dut();

            @(posedge clk);
            start_tx <= 1;
            @(posedge clk);
            start_tx <= 0;
            @(posedge clk);
            ack_received <= 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Stay in IDLE state", test_num);
            reset_dut();

            start_tx <= 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset while in WAIT_FOR_ACK", test_num);
            reset_dut();

            @(posedge clk);
            start_tx <= 1;
            @(posedge clk);
            @(posedge clk);
            rst_n <= 0;
            #10;
            rst_n <= 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Back-to-back Transmissions", test_num);
            reset_dut();


            @(posedge clk);
            start_tx <= 1;
            @(posedge clk);
            start_tx <= 0;
            @(posedge clk);
            ack_received <= 1;
            @(posedge clk);


            ack_received <= 0;
            start_tx <= 1;
            @(posedge clk);
            #1;
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
        $display("eth_mac_controller Testbench");
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
        $dumpvars(0,ack_received, clk, rst_n, start_tx, state);
    end

endmodule
