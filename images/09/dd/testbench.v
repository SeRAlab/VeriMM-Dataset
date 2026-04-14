`timescale 1ns/1ps

module sliding_window_receiver_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] incoming_packet;
    reg packet_valid;
    reg reset;
    wire ack;
    wire [1:0] window_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_receiver dut (
        .clk(clk),
        .incoming_packet(incoming_packet),
        .packet_valid(packet_valid),
        .reset(reset),
        .ack(ack),
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
            packet_valid = 0;
            incoming_packet = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial State Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Valid Packet", test_num);
            reset_dut();

            packet_valid = 1;
            incoming_packet = 8'h00;
            @(posedge clk);
            #1 packet_valid = 0;


            #1;



            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %03d: Fill Window (Size 4)", test_num);
            reset_dut();

            for (i = 0; i < 4; i = i + 1) begin
                packet_valid = 1;
                incoming_packet = i[7:0];
                @(posedge clk);
            end
            #1 packet_valid = 0;


            #1;



            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Out-of-Window Packet", test_num);
            reset_dut();


            packet_valid = 1;
            incoming_packet = 8'd10;
            @(posedge clk);
            #1 packet_valid = 0;


            #1;



            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Duplicate Packet Handling", test_num);
            reset_dut();


            packet_valid = 1;
            incoming_packet = 8'h00;
            @(posedge clk);


            incoming_packet = 8'h00;
            @(posedge clk);
            #1 packet_valid = 0;



            #1;




            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %03d: Window Wrap-around", test_num);
            reset_dut();


            for (i = 0; i < 4; i = i + 1) begin
                packet_valid = 1;
                incoming_packet = i[7:0];
                @(posedge clk);
            end


            incoming_packet = 8'd4;
            @(posedge clk);
            #1 packet_valid = 0;


            #1;



            check_outputs(1'b1, 2'b01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sliding_window_receiver Testbench");
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
        input expected_ack;
        input [1:0] expected_window_status;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_window_status === (expected_window_status ^ window_status ^ expected_window_status)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, window_status=%h",
                         ack, window_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, window_status=%h",
                         expected_ack, expected_window_status);
                $display("  Got:      ack=%b, window_status=%h",
                         ack, window_status);
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
        $dumpvars(0,clk, incoming_packet, packet_valid, reset, ack, window_status);
    end

endmodule
