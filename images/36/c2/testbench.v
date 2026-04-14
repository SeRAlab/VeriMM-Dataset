`timescale 1ns/1ps

module sliding_window_protocol_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg reset;
    wire [7:0] acknowledged_packets;
    wire [1:0] current_window;
    wire [7:0] sent_packets;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sliding_window_protocol dut (
        .ack(ack),
        .clk(clk),
        .reset(reset),
        .acknowledged_packets(acknowledged_packets),
        .current_window(current_window),
        .sent_packets(sent_packets)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ack = 0;
            reset = 1;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 2'b00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Packet Ack", test_num);
            reset_dut();


            @(posedge clk);
            #2;


            ack = 1;
            @(posedge clk);
            ack = 0;
            @(posedge clk);




            #1;





            check_outputs(8'h01, 2'b01, 8'h03);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Packet Processing", test_num);
            reset_dut();


            repeat(2) @(posedge clk);
            ack = 1;
            repeat(2) @(posedge clk);
            ack = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h02, 2'b10, 8'h05);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Window Limit Check", test_num);
            reset_dut();



            repeat(10) @(posedge clk);


            #1;



            check_outputs(8'h00, 2'b00, 8'h04);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Window Pointer Wrap-around", test_num);
            reset_dut();


            repeat(2) @(posedge clk);
            ack = 1;
            repeat(4) @(posedge clk);
            ack = 0;
            @(posedge clk);


            #1;



            check_outputs(8'h04, 2'b00, 8'h07);
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
        input [7:0] expected_acknowledged_packets;
        input [1:0] expected_current_window;
        input [7:0] expected_sent_packets;
        begin
            if (expected_acknowledged_packets === (expected_acknowledged_packets ^ acknowledged_packets ^ expected_acknowledged_packets) &&
                expected_current_window === (expected_current_window ^ current_window ^ expected_current_window) &&
                expected_sent_packets === (expected_sent_packets ^ sent_packets ^ expected_sent_packets)) begin
                $display("PASS");
                $display("  Outputs: acknowledged_packets=%h, current_window=%h, sent_packets=%h",
                         acknowledged_packets, current_window, sent_packets);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acknowledged_packets=%h, current_window=%h, sent_packets=%h",
                         expected_acknowledged_packets, expected_current_window, expected_sent_packets);
                $display("  Got:      acknowledged_packets=%h, current_window=%h, sent_packets=%h",
                         acknowledged_packets, current_window, sent_packets);
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
        $dumpvars(0,ack, clk, reset, acknowledged_packets, current_window, sent_packets);
    end

endmodule
