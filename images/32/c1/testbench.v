`timescale 1ns/1ps

module tcp_segmenter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg data_valid;
    reg rst_n;
    wire [7:0] packet_out;
    wire packet_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segmenter dut (
        .clk(clk),
        .data_in(data_in),
        .data_valid(data_valid),
        .rst_n(rst_n),
        .packet_out(packet_out),
        .packet_ready(packet_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            data_in = 0;
            data_valid = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single 4-byte segment", test_num);
            reset_dut();

            data_valid = 1;
            data_in = 8'h01; @(posedge clk);
            data_in = 8'h02; @(posedge clk);
            data_in = 8'h03; @(posedge clk);
            data_in = 8'h04;


            #1;



            check_outputs(8'h04, 1'b1);
            @(posedge clk);
            data_valid = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Two consecutive 4-byte segments", test_num);
            reset_dut();

            data_valid = 1;

            data_in = 8'h11; @(posedge clk);
            data_in = 8'h12; @(posedge clk);
            data_in = 8'h13; @(posedge clk);
            data_in = 8'h14; @(posedge clk);


            data_in = 8'h21; @(posedge clk);
            data_in = 8'h22; @(posedge clk);
            data_in = 8'h23; @(posedge clk);
            data_in = 8'h24;


            #1;



            check_outputs(8'h24, 1'b1);
            @(posedge clk);
            data_valid = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Segment with valid signal gaps", test_num);
            reset_dut();

            data_valid = 1; data_in = 8'hA1; @(posedge clk);
            data_valid = 0; data_in = 8'hFF; @(posedge clk);
            data_valid = 1; data_in = 8'hA2; @(posedge clk);
            data_valid = 1; data_in = 8'hA3; @(posedge clk);
            data_valid = 0; data_in = 8'hEE; @(posedge clk);
            data_valid = 1; data_in = 8'hA4;


            #1;



            check_outputs(8'hA4, 1'b1);
            @(posedge clk);
            data_valid = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset mid-transmission", test_num);
            reset_dut();


            data_valid = 1;
            data_in = 8'hB1; @(posedge clk);
            data_in = 8'hB2; @(posedge clk);
            data_in = 8'hB3; @(posedge clk);


            rst_n = 0; @(posedge clk);
            rst_n = 1; @(posedge clk);


            data_in = 8'hB4; data_valid = 1;
            #1;

            check_outputs(8'hB4, 1'b0);
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
        input [7:0] expected_packet_out;
        input expected_packet_ready;
        begin
            if (expected_packet_out === (expected_packet_out ^ packet_out ^ expected_packet_out) &&
                expected_packet_ready === (expected_packet_ready ^ packet_ready ^ expected_packet_ready)) begin
                $display("PASS");
                $display("  Outputs: packet_out=%h, packet_ready=%b",
                         packet_out, packet_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: packet_out=%h, packet_ready=%b",
                         expected_packet_out, expected_packet_ready);
                $display("  Got:      packet_out=%h, packet_ready=%b",
                         packet_out, packet_ready);
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
        $dumpvars(0,clk, data_in, data_valid, rst_n, packet_out, packet_ready);
    end

endmodule
