`timescale 1ns/1ps

module voltage_regulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [4:0] input_voltage;
    wire [4:0] output_voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_regulator dut (
        .clk(clk),
        .enable(enable),
        .input_voltage(input_voltage),
        .output_voltage(output_voltage)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            input_voltage = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Normal Operation - Input 5, Gain 2x", test_num);
            enable = 1;
            input_voltage = 5'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Normal Operation - Input 12, Gain 2x", test_num);
            enable = 1;
            input_voltage = 5'd12;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'd24);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Maximum Input without Overflow - Input 15", test_num);
            enable = 1;
            input_voltage = 5'd15;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Zero Input", test_num);
            enable = 1;
            input_voltage = 5'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Disabled Regulator (Enable Low)", test_num);
            enable = 0;
            input_voltage = 5'd10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: Overflow Case - Input 16", test_num);
            enable = 1;
            input_voltage = 5'd16;
            @(posedge clk);
            #2;

            #1;


            check_outputs(5'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Test %0d: Overflow Case - Max Input 31", test_num);
            enable = 1;
            input_voltage = 5'd31;
            @(posedge clk);
            #2;

            #1;


            check_outputs(5'd30);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            $display("Test %0d: Small Input - Input 1", test_num);
            enable = 1;
            input_voltage = 5'd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("voltage_regulator Testbench");
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
        input [4:0] expected_output_voltage;
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
        $dumpvars(0,clk, enable, input_voltage, output_voltage);
    end

endmodule
