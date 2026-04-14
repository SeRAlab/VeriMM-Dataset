`timescale 1ns/1ps

module tcp_segmenter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    reg reset;
    wire last_packet;
    wire [7:0] packet_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmenter dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .reset(reset),
        .last_packet(last_packet),
        .packet_out(packet_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h00;
            data_valid = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single Full Packet (4 Bytes)", test_num);
            reset_dut();


            data_valid = 1; data_in = 8'hAA; @(posedge clk);
            data_valid = 1; data_in = 8'hBB; @(posedge clk);
            data_valid = 1; data_in = 8'hCC; @(posedge clk);
            data_valid = 1; data_in = 8'hDD;


            #1 #1;
 check_outputs(1'b1, 8'hDD);
            @(posedge clk);
            data_valid = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Multiple Packets (8 Bytes total)", test_num);
            reset_dut();


            data_valid = 1; data_in = 8'h01; @(posedge clk);
            data_valid = 1; data_in = 8'h02; @(posedge clk);
            data_valid = 1; data_in = 8'h03; @(posedge clk);
            data_valid = 1; data_in = 8'h04; @(posedge clk);


            data_valid = 1; data_in = 8'h05; @(posedge clk);
            data_valid = 1; data_in = 8'h06; @(posedge clk);
            data_valid = 1; data_in = 8'h07; @(posedge clk);
            data_valid = 1; data_in = 8'h08;


            #1 #1;
 check_outputs(1'b1, 8'h08);
            @(posedge clk);
            data_valid = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Incomplete Packet (Only 2 Bytes)", test_num);
            reset_dut();

            data_valid = 1; data_in = 8'h11; @(posedge clk);
            data_valid = 1; data_in = 8'h22;


            #1 #1;
 check_outputs(1'b0, 8'h22);
            @(posedge clk);
            data_valid = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Packet with Gaps in data_valid", test_num);
            reset_dut();

            data_valid = 1; data_in = 8'hA1; @(posedge clk);
            data_valid = 0;                  @(posedge clk);
            data_valid = 1; data_in = 8'hA2; @(posedge clk);
            data_valid = 1; data_in = 8'hA3; @(posedge clk);
            data_valid = 0;                  @(posedge clk);
            data_valid = 1; data_in = 8'hA4;


            #1 #1;
 check_outputs(1'b1, 8'hA4);
            @(posedge clk);
            data_valid = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Check start of a new packet sequence", test_num);
            reset_dut();


            data_valid = 1; data_in = 8'hF1; @(posedge clk);
            data_valid = 1; data_in = 8'hF2; @(posedge clk);
            data_valid = 1; data_in = 8'hF3; @(posedge clk);
            data_valid = 1; data_in = 8'hF4; @(posedge clk);


            data_valid = 1; data_in = 8'hF5;


            #1 #1;
 check_outputs(1'b0, 8'hF5);
            @(posedge clk);
            data_valid = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("tcp_segmenter Testbench");
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
        input expected_last_packet;
        input [7:0] expected_packet_out;
        begin
            if (expected_last_packet === (expected_last_packet ^ last_packet ^ expected_last_packet) &&
                expected_packet_out === (expected_packet_out ^ packet_out ^ expected_packet_out)) begin
                $display("PASS");
                $display("  Outputs: last_packet=%b, packet_out=%h",
                         last_packet, packet_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: last_packet=%b, packet_out=%h",
                         expected_last_packet, expected_packet_out);
                $display("  Got:      last_packet=%b, packet_out=%h",
                         last_packet, packet_out);
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
        $dumpvars(0,clk, data_in, data_valid, reset, last_packet, packet_out);
    end

endmodule
