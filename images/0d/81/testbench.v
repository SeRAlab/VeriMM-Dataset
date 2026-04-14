`timescale 1ns/1ps

module packet_filter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] D_IP;
    reg [15:0] P_TYPE;
    reg [7:0] S_IP;
    wire [6:0] action;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    packet_filter dut (
        .D_IP(D_IP),
        .P_TYPE(P_TYPE),
        .S_IP(S_IP),
        .action(action)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Valid Packet - S_IP=AA, D_IP=55, P_TYPE=0001", test_num);
        S_IP   = 8'hAA;
        D_IP   = 8'h55;
        P_TYPE = 16'h0001;
        #1;

        check_outputs(ALLOW);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Valid Packet - S_IP=AA, D_IP=55, P_TYPE=0002", test_num);
        S_IP   = 8'hAA;
        D_IP   = 8'h55;
        P_TYPE = 16'h0002;
        #1;

        check_outputs(ALLOW);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Invalid Source IP (Expected DENY)", test_num);
        S_IP   = 8'hFF;
        D_IP   = 8'h55;
        P_TYPE = 16'h0001;
        #1;

        check_outputs(DENY);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Invalid Destination IP (Expected DENY)", test_num);
        S_IP   = 8'hAA;
        D_IP   = 8'h00;
        P_TYPE = 16'h0002;
        #1;

        check_outputs(DENY);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Invalid Packet Type (0x0003) (Expected DENY)", test_num);
        S_IP   = 8'hAA;
        D_IP   = 8'h55;
        P_TYPE = 16'h0003;
        #1;

        check_outputs(DENY);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Invalid Packet Type (0x0000) (Expected DENY)", test_num);
        S_IP   = 8'hAA;
        D_IP   = 8'h55;
        P_TYPE = 16'h0000;
        #1;

        check_outputs(DENY);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All Fields Incorrect (Expected DENY)", test_num);
        S_IP   = 8'h00;
        D_IP   = 8'h00;
        P_TYPE = 16'hFFFF;
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
        input [6:0] expected_action;
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
