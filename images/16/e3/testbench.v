`timescale 1ns/1ps

module sliding_window_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg receive_frame;
    reg reset;
    reg send_frame;
    wire [1:0] receiver_state;
    wire [1:0] sender_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_controller dut (
        .ack(ack),
        .clk(clk),
        .receive_frame(receive_frame),
        .reset(reset),
        .send_frame(send_frame),
        .receiver_state(receiver_state),
        .sender_state(sender_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ack = 0;
            receive_frame = 0;
            send_frame = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %03d: Initial Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %03d: Send single frame", test_num);
            reset_dut();
            send_frame = 1;
            @(posedge clk);
            send_frame = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b00, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %03d: Receive single frame", test_num);
            reset_dut();
            receive_frame = 1;
            @(posedge clk);
            receive_frame = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b01, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %03d: Sender state wrap-around (4 frames)", test_num);
            reset_dut();
            repeat(4) begin
                send_frame = 1;
                @(posedge clk);
                send_frame = 0;
                @(posedge clk);
            end
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %03d: Receiver state wrap-around (4 frames)", test_num);
            reset_dut();
            repeat(4) begin
                receive_frame = 1;
                @(posedge clk);
                receive_frame = 0;
                @(posedge clk);
            end
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %03d: Interleaved send and receive operations", test_num);
            reset_dut();

            send_frame = 1; @(posedge clk); send_frame = 0; @(posedge clk);

            receive_frame = 1; @(posedge clk); receive_frame = 0; @(posedge clk);

            send_frame = 1; @(posedge clk); send_frame = 0; @(posedge clk);

            #1;


            check_outputs(2'b01, 2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %03d: Simultaneous send and receive in one clock", test_num);
            reset_dut();
            send_frame = 1;
            receive_frame = 1;
            @(posedge clk);
            send_frame = 0;
            receive_frame = 0;
            @(posedge clk);
            #1;

            check_outputs(2'b01, 2'b01);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %03d: Ack signal interaction", test_num);
            reset_dut();
            send_frame = 1;
            @(posedge clk);
            send_frame = 0;
            ack = 1;
            @(posedge clk);
            ack = 0;
            @(posedge clk);


            #1;



            check_outputs(2'b00, 2'b01);
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
        input [1:0] expected_receiver_state;
        input [1:0] expected_sender_state;
        begin
            if (expected_receiver_state === (expected_receiver_state ^ receiver_state ^ expected_receiver_state) &&
                expected_sender_state === (expected_sender_state ^ sender_state ^ expected_sender_state)) begin
                $display("PASS");
                $display("  Outputs: receiver_state=%h, sender_state=%h",
                         receiver_state, sender_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: receiver_state=%h, sender_state=%h",
                         expected_receiver_state, expected_sender_state);
                $display("  Got:      receiver_state=%h, sender_state=%h",
                         receiver_state, sender_state);
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
        $dumpvars(0,ack, clk, receive_frame, reset, send_frame, receiver_state, sender_state);
    end

endmodule
