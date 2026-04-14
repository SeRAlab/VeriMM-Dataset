`timescale 1ns/1ps

module wifi_signal_strength_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] rssi1;
    reg [4:0] rssi2;
    wire [4:0] stronger_rssi;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_signal_strength dut (
        .rssi1(rssi1),
        .rssi2(rssi2),
        .stronger_rssi(stronger_rssi)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: Minimum Values (Both 0)", test_num);
        rssi1 = 5'd0;
        rssi2 = 5'd0;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Maximum Values (Both 31)", test_num);
        rssi1 = 5'd31;
        rssi2 = 5'd31;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: rssi1 > rssi2", test_num);
        rssi1 = 5'd20;
        rssi2 = 5'd10;
        #1;

        check_outputs(5'd20);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: rssi2 > rssi1", test_num);
        rssi1 = 5'd5;
        rssi2 = 5'd25;
        #1;

        check_outputs(5'd25);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Equal middle range values", test_num);
        rssi1 = 5'd15;
        rssi2 = 5'd15;
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: Small difference (rssi1 = rssi2 + 1)", test_num);
        rssi1 = 5'd16;
        rssi2 = 5'd15;
        #1;

        check_outputs(5'd16);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest Case %0d: Small difference (rssi2 = rssi1 + 1)", test_num);
        rssi1 = 5'd15;
        rssi2 = 5'd16;
        #1;

        check_outputs(5'd16);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTest Case %0d: Large difference (31 vs 0)", test_num);
        rssi1 = 5'd31;
        rssi2 = 5'd0;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTest Case %0d: Large difference (0 vs 31)", test_num);
        rssi1 = 5'd0;
        rssi2 = 5'd31;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTest Case %0d: Powers of 2", test_num);
        rssi1 = 5'd8;
        rssi2 = 5'd4;
        #1;

        check_outputs(5'd8);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wifi_signal_strength Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [4:0] expected_stronger_rssi;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_stronger_rssi === (expected_stronger_rssi ^ stronger_rssi ^ expected_stronger_rssi)) begin
                $display("PASS");
                $display("  Outputs: stronger_rssi=%h",
                         stronger_rssi);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stronger_rssi=%h",
                         expected_stronger_rssi);
                $display("  Got:      stronger_rssi=%h",
                         stronger_rssi);
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
