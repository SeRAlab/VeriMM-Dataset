`timescale 1ns/1ps

module sliding_window_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    reg send;
    wire [1:0] state;
    wire [3:0] window_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_controller dut (
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .send(send),
        .state(state),
        .window_status(window_status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            send = 0;
            ack = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Send Single Packet", test_num);
            reset_dut();
            send = 1;
            @(posedge clk);
            #1 send = 0;
            @(posedge clk);

            #1;


            check_outputs(2'b01, 4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Send and Acknowledge", test_num);
            reset_dut();

            send = 1; @(posedge clk); #1 send = 0;
            @(posedge clk);

            ack = 1; @(posedge clk); #1 ack = 0;
            @(posedge clk);

            #1;


            check_outputs(2'b00, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Fill Window to Capacity", test_num);
            reset_dut();

            repeat(4) begin
                send = 1; @(posedge clk); #1 send = 0;
                @(posedge clk);
            end

            #1;


            check_outputs(2'b11, 4'h4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Blocked Send (Overflow)", test_num);
            reset_dut();

            repeat(4) begin
                send = 1; @(posedge clk); #1 send = 0;
                @(posedge clk);
            end

            send = 1; @(posedge clk); #1 send = 0;
            @(posedge clk);

            #1;


            check_outputs(2'b11, 4'h4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Partial Clear Window", test_num);
            reset_dut();

            repeat(4) begin
                send = 1; @(posedge clk); #1 send = 0;
                @(posedge clk);
            end

            repeat(2) begin
                ack = 1; @(posedge clk); #1 ack = 0;
                @(posedge clk);
            end

            #1;


            check_outputs(2'b01, 4'h2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Acknowledge on Empty Window", test_num);
            reset_dut();

            ack = 1; @(posedge clk); #1 ack = 0;
            @(posedge clk);

            #1;


            check_outputs(2'b00, 4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simultaneous Send and Ack", test_num);
            reset_dut();

            send = 1; @(posedge clk); #1 send = 0;
            @(posedge clk);

            send = 1; ack = 1;
            @(posedge clk);
            #1 send = 0; ack = 0;
            @(posedge clk);

            #1;


            check_outputs(2'b01, 4'h1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sliding_window_controller Testbench");
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
        input [3:0] expected_window_status;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state) &&
                expected_window_status === (expected_window_status ^ window_status ^ expected_window_status)) begin
                $display("PASS");
                $display("  Outputs: state=%h, window_status=%h",
                         state, window_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h, window_status=%h",
                         expected_state, expected_window_status);
                $display("  Got:      state=%h, window_status=%h",
                         state, window_status);
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
        $dumpvars(0,ack, clk, reset, send, state, window_status);
    end

endmodule
