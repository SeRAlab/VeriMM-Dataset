`timescale 1ns/1ps

module temperature_sensor_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] temp_in;
    wire [2:0] status_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_sensor dut (
        .temp_in(temp_in),
        .status_out(status_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: temp_in = 0 (Minimum Low)", test_num);
        temp_in = 5'd0;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: temp_in = 9 (Boundary Low)", test_num);
        temp_in = 5'd9;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: temp_in = 10 (Lower Boundary Normal)", test_num);
        temp_in = 5'd10;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: temp_in = 18 (Normal Range)", test_num);
        temp_in = 5'd18;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: temp_in = 25 (Upper Boundary Normal)", test_num);
        temp_in = 5'd25;
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: temp_in = 26 (Lower Boundary High)", test_num);
        temp_in = 5'd26;
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: temp_in = 31 (Maximum High)", test_num);
        temp_in = 5'd31;
        #1;

        check_outputs(3'b010);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("temperature_sensor Testbench");
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
        input [2:0] expected_status_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_status_out === (expected_status_out ^ status_out ^ expected_status_out)) begin
                $display("PASS");
                $display("  Outputs: status_out=%h",
                         status_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: status_out=%h",
                         expected_status_out);
                $display("  Got:      status_out=%h",
                         status_out);
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
