`timescale 1ns/1ps

module sata_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg disconnect;
    reg rst_n;
    reg start_connect;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sata_controller dut (
        .clk(clk),
        .disconnect(disconnect),
        .rst_n(rst_n),
        .start_connect(start_connect),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 1'b0;
            start_connect = 1'b0;
            disconnect = 1'b0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1'b1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Power-on Reset to IDLE", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Transition IDLE to CONNECTING", test_num);
            reset_dut();
            @(posedge clk);
            start_connect = 1'b1;
            @(posedge clk);
            #1 start_connect = 1'b0;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Transition to CONNECTED state", test_num);
            reset_dut();
            @(posedge clk);
            start_connect = 1'b1;
            @(posedge clk);
            start_connect = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Transition CONNECTED to DISCONNECTED", test_num);
            reset_dut();

            @(posedge clk);
            start_connect = 1'b1;
            repeat(2) @(posedge clk);
            start_connect = 1'b0;

            disconnect = 1'b1;
            @(posedge clk);
            #1 disconnect = 1'b0;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Return to IDLE from DISCONNECTED", test_num);
            reset_dut();

            @(posedge clk); start_connect = 1'b1;
            repeat(2) @(posedge clk);
            start_connect = 1'b0;

            disconnect = 1'b1;
            @(posedge clk);
            disconnect = 1'b0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Asynchronous Reset during CONNECTING state", test_num);
            reset_dut();
            @(posedge clk);
            start_connect = 1'b1;
            @(posedge clk);
            #2 rst_n = 1'b0;
            #10;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: IDLE remains IDLE without command", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sata_controller Testbench");
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
        $dumpvars(0,clk, disconnect, rst_n, start_connect, state);
    end

endmodule
