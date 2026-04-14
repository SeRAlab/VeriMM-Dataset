`timescale 1ns/1ps

module vco_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] control_voltage;
    wire vco_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    vco dut (
        .clk(clk),
        .control_voltage(control_voltage),
        .vco_out(vco_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            control_voltage = 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Testing 32kHz (1111) - High phase check", test_num);
            control_voltage = 4'b1111;
            #10000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Testing 32kHz (1111) - Low phase check", test_num);
            control_voltage = 4'b1111;
            #25000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Testing 16kHz (1110) - High phase check", test_num);
            control_voltage = 4'b1110;
            #20000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Testing 16kHz (1110) - Low phase check", test_num);
            control_voltage = 4'b1110;
            #50000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Testing 8kHz (1101) - High phase check", test_num);
            control_voltage = 4'b1101;
            #40000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %0d: Testing 8kHz (1101) - Low phase check", test_num);
            control_voltage = 4'b1101;
            #100000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Testcase %0d: Testing 4kHz (1100) - High phase check", test_num);
            control_voltage = 4'b1100;
            #80000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            $display("Testcase %0d: Testing 2kHz (1011) - High phase check", test_num);
            control_voltage = 4'b1011;
            #150000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("vco Testbench");
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
        input expected_vco_out;
        begin
            if (expected_vco_out === (expected_vco_out ^ vco_out ^ expected_vco_out)) begin
                $display("PASS");
                $display("  Outputs: vco_out=%b",
                         vco_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vco_out=%b",
                         expected_vco_out);
                $display("  Got:      vco_out=%b",
                         vco_out);
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
        $dumpvars(0,clk, control_voltage, vco_out);
    end

endmodule
