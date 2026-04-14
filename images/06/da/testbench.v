`timescale 1ns/1ps

module wifi_status_indicator_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] connection_status;
    reg [4:0] signal_strength;
    wire [4:0] wifi_status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_status_indicator dut (
        .connection_status(connection_status),
        .signal_strength(signal_strength),
        .wifi_status(wifi_status)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Disconnected, Signal=5", test_num);
        connection_status = 5'd0;
        signal_strength = 5'd5;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Disconnected, Signal=25", test_num);
        connection_status = 5'd0;
        signal_strength = 5'd25;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Connected, Signal=10 (Weak Boundary)", test_num);
        connection_status = 5'd1;
        signal_strength = 5'd10;
        #1;

        check_outputs(5'b00001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Connected, Signal=11 (Strong Boundary)", test_num);
        connection_status = 5'd1;
        signal_strength = 5'd11;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Connected, Signal=0", test_num);
        connection_status = 5'd1;
        signal_strength = 5'd0;
        #1;

        check_outputs(5'b00001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Connected, Signal=31", test_num);
        connection_status = 5'd1;
        signal_strength = 5'd31;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Disconnected, Signal=0", test_num);
        connection_status = 5'd0;
        signal_strength = 5'd0;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wifi_status_indicator Testbench");
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
        input [4:0] expected_wifi_status;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_wifi_status === (expected_wifi_status ^ wifi_status ^ expected_wifi_status)) begin
                $display("PASS");
                $display("  Outputs: wifi_status=%h",
                         wifi_status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wifi_status=%h",
                         expected_wifi_status);
                $display("  Got:      wifi_status=%h",
                         wifi_status);
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
