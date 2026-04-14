`timescale 1ns/1ps

module dvfs_control_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] load;
    reg [1:0] voltage;
    wire [1:0] frequency;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dvfs_control dut (
        .load(load),
        .voltage(voltage),
        .frequency(frequency)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Voltage=00, Load=000", test_num);
        voltage = 2'b00;
        load = 3'b000;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Voltage=00, Load=111", test_num);
        voltage = 2'b00;
        load = 3'b111;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Voltage=01, Load=000", test_num);
        voltage = 2'b01;
        load = 3'b000;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Voltage=01, Load=010", test_num);
        voltage = 2'b01;
        load = 3'b010;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Voltage=01, Load=011", test_num);
        voltage = 2'b01;
        load = 3'b011;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Voltage=01, Load=101", test_num);
        voltage = 2'b01;
        load = 3'b101;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Voltage=01, Load=110", test_num);
        voltage = 2'b01;
        load = 3'b110;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Voltage=01, Load=111", test_num);
        voltage = 2'b01;
        load = 3'b111;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Voltage=10, Load=000", test_num);
        voltage = 2'b10;
        load = 3'b000;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Voltage=10, Load=010", test_num);
        voltage = 2'b10;
        load = 3'b010;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Voltage=10, Load=011", test_num);
        voltage = 2'b10;
        load = 3'b011;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Voltage=10, Load=111", test_num);
        voltage = 2'b10;
        load = 3'b111;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Voltage=11, Load=000", test_num);
        voltage = 2'b11;
        load = 3'b000;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Voltage=11, Load=111", test_num);
        voltage = 2'b11;
        load = 3'b111;
        #1;

        check_outputs(2'b11);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dvfs_control Testbench");
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
        testcase014();
        
        
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
        input [1:0] expected_frequency;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_frequency === (expected_frequency ^ frequency ^ expected_frequency)) begin
                $display("PASS");
                $display("  Outputs: frequency=%h",
                         frequency);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frequency=%h",
                         expected_frequency);
                $display("  Got:      frequency=%h",
                         frequency);
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
