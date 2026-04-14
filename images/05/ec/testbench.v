`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] ack_id;
    reg clk;
    reg rst;
    reg send_enable;
    wire [3:0] packet_id;
    wire send_valid;
    wire [3:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack_id(ack_id),
        .clk(clk),
        .rst(rst),
        .send_enable(send_enable),
        .packet_id(packet_id),
        .send_valid(send_valid),
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
            send_enable = 0;
            ack_id = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset State Check");
            reset_dut();

            #1;


            check_outputs(4'h0, 1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Single Packet Transmission");
            reset_dut();
            @(posedge clk);
            send_enable = 1;
            #(10);
            send_enable = 0;
            @(posedge clk);

            #1;


            check_outputs(4'h0, 1'b1, 4'h1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("\nRunning testcase003: Fill Window Transmission");
            reset_dut();
            for(i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                send_enable = 1;
                #10;
                send_enable = 0;
                #10;
            end


            #1;



            check_outputs(4'h3, 1'b1, 4'h2);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("\nRunning testcase004: Window Blocking Check");
            reset_dut();

            for(i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                send_enable = 1;
                #10;
            end

            @(posedge clk);
            send_enable = 1;
            #10;
            send_enable = 0;


            #1;



            check_outputs(4'h3, 1'b0, 4'h2);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("\nRunning testcase005: Sliding Window Movement (ACK one)");
            reset_dut();

            for(i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                send_enable = 1;
                #10;
            end

            @(posedge clk);
            send_enable = 0;
            ack_id = 4'h0;
            #10;

            @(posedge clk);
            send_enable = 1;
            #10;
            send_enable = 0;


            #1;



            check_outputs(4'h4, 1'b1, 4'h1);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("\nRunning testcase006: Bulk Acknowledgment");
            reset_dut();

            for(i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                send_enable = 1;
                #10;
            end

            @(posedge clk);
            send_enable = 0;
            ack_id = 4'h2;
            #10;


            @(posedge clk);
            send_enable = 1;
            #10;
            send_enable = 0;
            #1;

            check_outputs(4'h4, 1'b1, 4'h1);
        end
        endtask

    task testcase007;

        integer i;
        begin
            $display("\nRunning testcase007: ID Wrap-around");
            reset_dut();

            for(i = 0; i < 15; i = i + 1) begin
                @(posedge clk);
                send_enable = 1;
                #10;
                ack_id = i[3:0];
                #10;
            end

            @(posedge clk);
            send_enable = 1;
            #10;

            ack_id = 4'hF;
            #10;

            @(posedge clk);
            send_enable = 1;
            #10;
            send_enable = 0;
            #1;

            check_outputs(4'h0, 1'b1, 4'h1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sliding_window_protocol Testbench");
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
        input [3:0] expected_packet_id;
        input expected_send_valid;
        input [3:0] expected_state;
        begin
            if (expected_packet_id === (expected_packet_id ^ packet_id ^ expected_packet_id) &&
                expected_send_valid === (expected_send_valid ^ send_valid ^ expected_send_valid) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: packet_id=%h, send_valid=%b, state=%h",
                         packet_id, send_valid, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: packet_id=%h, send_valid=%b, state=%h",
                         expected_packet_id, expected_send_valid, expected_state);
                $display("  Got:      packet_id=%h, send_valid=%b, state=%h",
                         packet_id, send_valid, state);
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
        $dumpvars(0,ack_id, clk, rst, send_enable, packet_id, send_valid, state);
    end

endmodule
