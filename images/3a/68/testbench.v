`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    reg send_packet;
    wire [7:0] current_window;
    wire empty;
    wire full;
    wire [7:0] packet_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .send_packet(send_packet),
        .current_window(current_window),
        .empty(empty),
        .full(full),
        .packet_out(packet_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ack = 0;
            send_packet = 0;
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Verify Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b1, 1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Send Single Packet", test_num);
            reset_dut();

            send_packet = 1;
            @(posedge clk);
            #1;
            send_packet = 0;
            @(posedge clk);
            #1;




            #1;





            check_outputs(8'h01, 1'b0, 1'b0, packet_out);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("\nTestcase %0d: Fill Window Capacity", test_num);
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin
                send_packet = 1;
                @(posedge clk);
                #1;
            end
            send_packet = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h08, 1'b0, 1'b1, packet_out);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Acknowledge Packet to Slide Window", test_num);
            reset_dut();


            send_packet = 1;
            @(posedge clk); #1;
            @(posedge clk); #1;
            send_packet = 0;


            ack = 1;
            @(posedge clk); #1;
            ack = 0;
            @(posedge clk); #1;


            #1;



            check_outputs(8'h01, 1'b0, 1'b0, packet_out);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("\nTestcase %0d: Window Recovery after Full", test_num);
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin
                send_packet = 1;
                @(posedge clk); #1;
            end
            send_packet = 0;


            ack = 1;
            @(posedge clk); #1;
            @(posedge clk); #1;
            ack = 0;
            @(posedge clk); #1;


            #1;



            check_outputs(8'h06, 1'b0, 1'b0, packet_out);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("\nTestcase %0d: Full Cycle Empty-Full-Empty", test_num);
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin
                send_packet = 1;
                @(posedge clk); #1;
            end
            send_packet = 0;


            ack = 1;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk); #1;
            end
            ack = 0;
            @(posedge clk); #1;


            #1;



            check_outputs(8'h00, 1'b1, 1'b0, packet_out);
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
        input [7:0] expected_current_window;
        input expected_empty;
        input expected_full;
        input [7:0] expected_packet_out;
        begin
            if (expected_current_window === (expected_current_window ^ current_window ^ expected_current_window) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_packet_out === (expected_packet_out ^ packet_out ^ expected_packet_out)) begin
                $display("PASS");
                $display("  Outputs: current_window=%h, empty=%b, full=%b, packet_out=%h",
                         current_window, empty, full, packet_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_window=%h, empty=%b, full=%b, packet_out=%h",
                         expected_current_window, expected_empty, expected_full, expected_packet_out);
                $display("  Got:      current_window=%h, empty=%b, full=%b, packet_out=%h",
                         current_window, empty, full, packet_out);
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
        $dumpvars(0,ack, clk, reset, send_packet, current_window, empty, full, packet_out);
    end

endmodule
