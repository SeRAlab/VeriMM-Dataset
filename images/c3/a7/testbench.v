`timescale 1ns/1ps

module property_checker_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [3:0] data;
    reg reset;
    wire property_met;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    property_checker dut (
        .clock(clock),
        .data(data),
        .reset(reset),
        .property_met(property_met)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            data = 4'b0000;
            @(posedge clock);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: 3 consecutive 4'b1100", test_num);
            reset_dut();
            @(posedge clock) data <= 4'b1100;
            @(posedge clock) data <= 4'b1100;
            @(posedge clock) data <= 4'b1100;
            @(posedge clock);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: 2 consecutive 4'b1100, then mismatch", test_num);
            reset_dut();
            @(posedge clock) data <= 4'b1100;
            @(posedge clock) data <= 4'b1100;
            @(posedge clock) data <= 4'b0000;
            @(posedge clock);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Interrupted sequence (1100, 0000, 1100, 1100)", test_num);
            reset_dut();
            @(posedge clock) data <= 4'b1100;
            @(posedge clock) data <= 4'b0000;
            @(posedge clock) data <= 4'b1100;
            @(posedge clock) data <= 4'b1100;
            @(posedge clock);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: 4 consecutive 4'b1100", test_num);
            reset_dut();
            @(posedge clock) data <= 4'b1100;
            @(posedge clock) data <= 4'b1100;
            @(posedge clock) data <= 4'b1100;
            @(posedge clock) data <= 4'b1100;
            @(posedge clock);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Reset applied during sequence", test_num);
            reset_dut();
            @(posedge clock) data <= 4'b1100;
            @(posedge clock) data <= 4'b1100;
            @(posedge clock) reset <= 1;
            @(posedge clock) reset <= 0; data <= 4'b1100;
            @(posedge clock);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: No matching data", test_num);
            reset_dut();
            repeat(4) @(posedge clock) data <= 4'b1010;
            @(posedge clock);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("property_checker Testbench");
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
        input expected_property_met;
        begin
            if (expected_property_met === (expected_property_met ^ property_met ^ expected_property_met)) begin
                $display("PASS");
                $display("  Outputs: property_met=%b",
                         property_met);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: property_met=%b",
                         expected_property_met);
                $display("  Got:      property_met=%b",
                         property_met);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clock, data, reset, property_met);
    end

endmodule
