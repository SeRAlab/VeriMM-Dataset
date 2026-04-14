`timescale 1ns/1ps

module tcp_segment_parser_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] tcp_segment;
    wire [31:0] ack_num;
    wire [15:0] checksum;
    wire [8:0] control_flags;
    wire [3:0] data_offset;
    wire [15:0] dest_port;
    wire [2:0] reserved;
    wire [31:0] seq_num;
    wire [15:0] src_port;
    wire [15:0] urgent_pointer;
    wire [15:0] window_size;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    tcp_segment_parser dut (
        .tcp_segment(tcp_segment),
        .ack_num(ack_num),
        .checksum(checksum),
        .control_flags(control_flags),
        .data_offset(data_offset),
        .dest_port(dest_port),
        .reserved(reserved),
        .seq_num(seq_num),
        .src_port(src_port),
        .urgent_pointer(urgent_pointer),
        .window_size(window_size)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: All Zeros");
            tcp_segment = 160'h0;

            #1;


            check_outputs(32'h0, 16'h0, 9'h0, 4'h0, 16'h0, 3'h0, 32'h0, 16'h0, 16'h0, 16'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: All Ones");
            tcp_segment = {160{1'b1}};
            #1;

            check_outputs(32'hFFFFFFFF, 16'hFFFF, 9'h1FF, 4'hF, 16'hFFFF, 3'h7, 32'hFFFFFFFF, 16'hFFFF, 16'hFFFF, 16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: SYN Packet");
            tcp_segment = {16'd1234, 16'd80, 32'hDEADBEEF, 32'h0, 4'h5, 3'h0, 9'h002, 16'hFFFF, 16'h1234, 16'h0000};
            #1;

            check_outputs(32'h0, 16'h1234, 9'h002, 4'h5, 16'd80, 3'h0, 32'hDEADBEEF, 16'd1234, 16'h0000, 16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: ACK+PSH Packet");
            tcp_segment = {16'd443, 16'd54321, 32'h1, 32'h2, 4'h8, 3'h0, 9'h018, 16'h1000, 16'hAAAA, 16'h0000};
            #1;

            check_outputs(32'h2, 16'hAAAA, 9'h018, 4'h8, 16'd54321, 3'h0, 32'h1, 16'd443, 16'h0000, 16'h1000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Boundary Values");
            tcp_segment = {16'hFFFF, 16'h0001, 32'h7FFFFFFF, 32'h80000000, 4'hA, 3'h4, 9'h155, 16'h00FF, 16'hF0F0, 16'h0F0F};
            #1;

            check_outputs(32'h80000000, 16'hF0F0, 9'h155, 4'hA, 16'h0001, 3'h4, 32'h7FFFFFFF, 16'hFFFF, 16'h0F0F, 16'h00FF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Alternating Patterns");
            tcp_segment = {160{2'b10}};
            #1;

            check_outputs(32'hAAAAAAAA, 16'hAAAA, 9'h0AA, 4'hA, 16'hAAAA, 3'h5, 32'hAAAAAAAA, 16'hAAAA, 16'hAAAA, 16'hAAAA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("tcp_segment_parser Testbench");
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
        input [31:0] expected_ack_num;
        input [15:0] expected_checksum;
        input [8:0] expected_control_flags;
        input [3:0] expected_data_offset;
        input [15:0] expected_dest_port;
        input [2:0] expected_reserved;
        input [31:0] expected_seq_num;
        input [15:0] expected_src_port;
        input [15:0] expected_urgent_pointer;
        input [15:0] expected_window_size;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ack_num === (expected_ack_num ^ ack_num ^ expected_ack_num) &&
                expected_checksum === (expected_checksum ^ checksum ^ expected_checksum) &&
                expected_control_flags === (expected_control_flags ^ control_flags ^ expected_control_flags) &&
                expected_data_offset === (expected_data_offset ^ data_offset ^ expected_data_offset) &&
                expected_dest_port === (expected_dest_port ^ dest_port ^ expected_dest_port) &&
                expected_reserved === (expected_reserved ^ reserved ^ expected_reserved) &&
                expected_seq_num === (expected_seq_num ^ seq_num ^ expected_seq_num) &&
                expected_src_port === (expected_src_port ^ src_port ^ expected_src_port) &&
                expected_urgent_pointer === (expected_urgent_pointer ^ urgent_pointer ^ expected_urgent_pointer) &&
                expected_window_size === (expected_window_size ^ window_size ^ expected_window_size)) begin
                $display("PASS");
                $display("  Outputs: ack_num=%h, checksum=%h, control_flags=%h, data_offset=%h, dest_port=%h, reserved=%h, seq_num=%h, src_port=%h, urgent_pointer=%h, window_size=%h",
                         ack_num, checksum, control_flags, data_offset, dest_port, reserved, seq_num, src_port, urgent_pointer, window_size);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack_num=%h, checksum=%h, control_flags=%h, data_offset=%h, dest_port=%h, reserved=%h, seq_num=%h, src_port=%h, urgent_pointer=%h, window_size=%h",
                         expected_ack_num, expected_checksum, expected_control_flags, expected_data_offset, expected_dest_port, expected_reserved, expected_seq_num, expected_src_port, expected_urgent_pointer, expected_window_size);
                $display("  Got:      ack_num=%h, checksum=%h, control_flags=%h, data_offset=%h, dest_port=%h, reserved=%h, seq_num=%h, src_port=%h, urgent_pointer=%h, window_size=%h",
                         ack_num, checksum, control_flags, data_offset, dest_port, reserved, seq_num, src_port, urgent_pointer, window_size);
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

endmodule
