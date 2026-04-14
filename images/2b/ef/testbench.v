`timescale 1ns/1ps

module vco_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] voltage;
    wire vco_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    vco dut (
        .clk(clk),
        .voltage(voltage),
        .vco_out(vco_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            voltage = 4'b0000;
            repeat(5) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Minimum Voltage (V=1)", test_num);
            reset_dut();
            voltage = 4'd1;

            repeat(128) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Medium-Low Voltage (V=4)", test_num);
            reset_dut();
            voltage = 4'd4;

            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-range Voltage (V=8)", test_num);
            reset_dut();
            voltage = 4'd8;

            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Voltage (V=15)", test_num);
            reset_dut();
            voltage = 4'd15;

            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Voltage (V=0)", test_num);
            reset_dut();
            voltage = 4'd0;

            repeat(100) @(posedge clk);
            #1;
            #1;

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
        $display("vco Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        $dumpvars(0,clk, voltage, vco_out);
    end

endmodule
