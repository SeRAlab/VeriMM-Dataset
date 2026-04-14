`timescale 1ns/1ps

module LDO_Regulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control_signal;
    reg [7:0] ref_voltage;
    reg reset;
    wire [7:0] output_voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO_Regulator dut (
        .clk(clk),
        .control_signal(control_signal),
        .ref_voltage(ref_voltage),
        .reset(reset),
        .output_voltage(output_voltage)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            control_signal = 0;
            ref_voltage = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Reference Voltage", test_num);
            reset_dut();

            ref_voltage = 8'h00;
            control_signal = 1;


            repeat (5) @(posedge clk);


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid-range Reference Voltage", test_num);
            reset_dut();

            ref_voltage = 8'h7F;
            control_signal = 1;


            repeat (10) @(posedge clk);


            #1;



            check_outputs(8'h7F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: High Reference Voltage", test_num);
            reset_dut();

            ref_voltage = 8'hFF;
            control_signal = 1;

            repeat (10) @(posedge clk);

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Control Signal Disabled", test_num);
            reset_dut();

            ref_voltage = 8'hA0;
            control_signal = 0;

            repeat (10) @(posedge clk);



            #1;




            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dynamic Reference Change", test_num);
            reset_dut();


            ref_voltage = 8'h40;
            control_signal = 1;
            repeat (5) @(posedge clk);


            ref_voltage = 8'h80;
            repeat (10) @(posedge clk);

            #1;


            check_outputs(8'h80);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Recovery during Operation", test_num);
            reset_dut();

            ref_voltage = 8'hCC;
            control_signal = 1;
            repeat (5) @(posedge clk);


            reset = 1;
            @(posedge clk);

            #1;


            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LDO_Regulator Testbench");
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
        input [7:0] expected_output_voltage;
        begin
            if (expected_output_voltage === (expected_output_voltage ^ output_voltage ^ expected_output_voltage)) begin
                $display("PASS");
                $display("  Outputs: output_voltage=%h",
                         output_voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_voltage=%h",
                         expected_output_voltage);
                $display("  Got:      output_voltage=%h",
                         output_voltage);
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
        $dumpvars(0,clk, control_signal, ref_voltage, reset, output_voltage);
    end

endmodule
