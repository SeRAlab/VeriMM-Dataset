`timescale 1ns/1ps

module temperature_sensor_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] temp;
    wire [2:0] category;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_sensor dut (
        .temp(temp),
        .category(category)
    );
    task testcase001;

        begin
            test_num = 1;
            temp = 5'd0;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            temp = 5'd8;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            temp = 5'd15;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            temp = 5'd16;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            temp = 5'd20;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            temp = 5'd25;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            temp = 5'd26;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            temp = 5'd31;
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
        testcase008();
        
        
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
        input [2:0] expected_category;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_category === (expected_category ^ category ^ expected_category)) begin
                $display("PASS");
                $display("  Outputs: category=%h",
                         category);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: category=%h",
                         expected_category);
                $display("  Got:      category=%h",
                         category);
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
