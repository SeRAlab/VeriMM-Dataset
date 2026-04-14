`timescale 1ns/1ps

module dvfs_controller_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] load;
    wire [2:0] frequency;
    wire [2:0] voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_controller dut (
        .load(load),
        .frequency(frequency),
        .voltage(voltage)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 0000", test_num);
            load = 4'b0000;
            #1;

            check_outputs(3'b000, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 0001", test_num);
            load = 4'b0001;
            #1;

            check_outputs(3'b001, 3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 0010", test_num);
            load = 4'b0010;
            #1;

            check_outputs(3'b010, 3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 0011", test_num);
            load = 4'b0011;
            #1;

            check_outputs(3'b011, 3'b011);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 0100", test_num);
            load = 4'b0100;
            #1;

            check_outputs(3'b100, 3'b100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 0101", test_num);
            load = 4'b0101;
            #1;

            check_outputs(3'b101, 3'b101);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 0110", test_num);
            load = 4'b0110;
            #1;

            check_outputs(3'b110, 3'b110);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 0111 (Lower bound of high load)", test_num);
            load = 4'b0111;
            #1;

            check_outputs(3'b111, 3'b111);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 1010 (Higher load)", test_num);
            load = 4'b1010;
            #1;

            check_outputs(3'b111, 3'b111);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 1111 (Maximum load)", test_num);
            load = 4'b1111;
            #1;

            check_outputs(3'b111, 3'b111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dvfs_controller Testbench");
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
        input [2:0] expected_frequency;
        input [2:0] expected_voltage;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_frequency === (expected_frequency ^ frequency ^ expected_frequency) &&
                expected_voltage === (expected_voltage ^ voltage ^ expected_voltage)) begin
                $display("PASS");
                $display("  Outputs: frequency=%h, voltage=%h",
                         frequency, voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency=%h, voltage=%h",
                         expected_frequency, expected_voltage);
                $display("  Got:      frequency=%h, voltage=%h",
                         frequency, voltage);
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
