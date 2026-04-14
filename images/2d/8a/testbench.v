`timescale 1ns/1ps

module temp_sensor_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] temp_in;
    wire [4:0] temp_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temp_sensor dut (
        .temp_in(temp_in),
        .temp_out(temp_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Category 0 - Extreme Negative (-512)", test_num);
        temp_in = 10'sd-512;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Category 0 - Typical Negative (-15)", test_num);
        temp_in = 10'sd-15;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Category 0 - Boundary (-1)", test_num);
        temp_in = 10'sd-1;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Category 1 - Lower Bound (0)", test_num);
        temp_in = 10'sd0;
        #1;

        check_outputs(5'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Category 1 - Midpoint (5)", test_num);
        temp_in = 10'sd5;
        #1;

        check_outputs(5'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Category 1 - Upper Bound (10)", test_num);
        temp_in = 10'sd10;
        #1;

        check_outputs(5'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Category 2 - Lower Bound (11)", test_num);
        temp_in = 10'sd11;
        #1;

        check_outputs(5'd2);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Category 2 - Upper Bound (20)", test_num);
        temp_in = 10'sd20;
        #1;

        check_outputs(5'd2);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Category 3 - Lower Bound (21)", test_num);
        temp_in = 10'sd21;
        #1;

        check_outputs(5'd3);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Category 3 - Upper Bound (30)", test_num);
        temp_in = 10'sd30;
        #1;

        check_outputs(5'd3);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Category 4 - Boundary (31)", test_num);
        temp_in = 10'sd31;
        #1;

        check_outputs(5'd4);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Category 4 - High Temp (100)", test_num);
        temp_in = 10'sd100;
        #1;

        check_outputs(5'd4);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Category 4 - Max Range (511)", test_num);
        temp_in = 10'sd511;
        #1;

        check_outputs(5'd4);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("temp_sensor Testbench");
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
        testcase011();
        testcase012();
        testcase013();
        
        
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
        input [4:0] expected_temp_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_temp_out === (expected_temp_out ^ temp_out ^ expected_temp_out)) begin
                $display("PASS");
                $display("  Outputs: temp_out=%h",
                         temp_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: temp_out=%h",
                         expected_temp_out);
                $display("  Got:      temp_out=%h",
                         temp_out);
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
