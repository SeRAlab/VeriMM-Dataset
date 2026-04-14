`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] dest_port;
    reg [31:0] src_ip;
    wire [7:0] action;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .dest_port(dest_port),
        .src_ip(src_ip),
        .action(action)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            src_ip = ALLOWED_IP;
            dest_port = ALLOWED_PORT;
            #1;

            check_outputs(ALLOW);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            src_ip = ALLOWED_IP;
            dest_port = 16'd443;
            #1;

            check_outputs(DENY);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            src_ip = 32'h0A000001;
            dest_port = ALLOWED_PORT;
            #1;

            check_outputs(DENY);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            src_ip = 32'h08080808;
            dest_port = 16'd22;
            #1;

            check_outputs(DENY);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            src_ip = 32'h0;
            dest_port = 16'h0;
            #1;

            check_outputs(DENY);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            src_ip = 32'hFFFFFFFF;
            dest_port = 16'hFFFF;
            #1;

            check_outputs(DENY);
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
        input [7:0] expected_action;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_action === (expected_action ^ action ^ expected_action)) begin
                $display("PASS");
                $display("  Outputs: action=%h",
                         action);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: action=%h",
                         expected_action);
                $display("  Got:      action=%h",
                         action);
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
