`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg control_signal;
    reg [3:0] dest_port;
    reg [4:0] source_ip;
    wire packet_allowed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .control_signal(control_signal),
        .dest_port(dest_port),
        .source_ip(source_ip),
        .packet_allowed(packet_allowed)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Control signal high, source_ip=0, dest_port=0");
            control_signal = 1'b1;
            source_ip = 5'b00000;
            dest_port = 4'b0000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Control signal low, source_ip=0, dest_port=0");
            control_signal = 1'b0;
            source_ip = 5'b00000;
            dest_port = 4'b0000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Control signal high, source_ip=10101, dest_port=1010");
            control_signal = 1'b1;
            source_ip = 5'b10101;
            dest_port = 4'b1010;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Control signal low, source_ip=11111, dest_port=1111");
            control_signal = 1'b0;
            source_ip = 5'b11111;
            dest_port = 4'b1111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Control signal high, source_ip=31, dest_port=15");
            control_signal = 1'b1;
            source_ip = 5'd31;
            dest_port = 4'd15;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Control signal toggled from 1 to 0");

            control_signal = 1'b1;
            source_ip = 5'b11001;
            dest_port = 4'b0110;
            #5;

            control_signal = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case 007: Control signal high, source_ip=01010, dest_port=0101");
            control_signal = 1'b1;
            source_ip = 5'b01010;
            dest_port = 4'b0101;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("packet_filter Testbench");
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
        input expected_packet_allowed;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_packet_allowed === (expected_packet_allowed ^ packet_allowed ^ expected_packet_allowed)) begin
                $display("PASS");
                $display("  Outputs: packet_allowed=%b",
                         packet_allowed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: packet_allowed=%b",
                         expected_packet_allowed);
                $display("  Got:      packet_allowed=%b",
                         packet_allowed);
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
