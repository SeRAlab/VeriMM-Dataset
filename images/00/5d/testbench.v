`timescale 1ns/1ps

module current_sensor_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] current_level;
    wire [2:0] severity;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    current_sensor dut (
        .current_level(current_level),
        .severity(severity)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: current_level = 0 (Lower Normal boundary)", test_num);
        current_level = 5'd0;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: current_level = 10 (Upper Normal boundary)", test_num);
        current_level = 5'd10;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: current_level = 11 (Lower Warning boundary)", test_num);
        current_level = 5'd11;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: current_level = 15 (Inside Warning range)", test_num);
        current_level = 5'd15;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: current_level = 20 (Upper Warning boundary)", test_num);
        current_level = 5'd20;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: current_level = 21 (Lower Critical boundary)", test_num);
        current_level = 5'd21;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: current_level = 25 (Inside Critical range)", test_num);
        current_level = 5'd25;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: current_level = 30 (Upper Critical boundary)", test_num);
        current_level = 5'd30;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: current_level = 31 (Danger range)", test_num);
        current_level = 5'd31;
        #1;

        check_outputs(3'b011);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("current_sensor Testbench");
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
        input [2:0] expected_severity;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_severity === (expected_severity ^ severity ^ expected_severity)) begin
                $display("PASS");
                $display("  Outputs: severity=%h",
                         severity);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: severity=%h",
                         expected_severity);
                $display("  Got:      severity=%h",
                         severity);
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
