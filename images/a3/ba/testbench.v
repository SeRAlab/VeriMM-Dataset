`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] load_value;
    reg shift_enable;
    wire [7:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .load(load),
        .load_value(load_value),
        .shift_enable(shift_enable),
        .data(data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            load = 1;
            load_value = 8'h00;
            shift_enable = 0;
            @(negedge clk);
            load = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Parallel Load", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            load_value = 8'hA5;
            @(negedge clk);
            load = 0;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Shift Left", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            load_value = 8'h01;
            @(negedge clk);
            load = 0;
            shift_enable = 1;
            @(negedge clk);
            shift_enable = 0;

            #1;


            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Multiple Shifts Left", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            load_value = 8'h01;
            @(negedge clk);
            load = 0;
            shift_enable = 1;
            repeat(4) @(negedge clk);
            shift_enable = 0;

            #1;


            check_outputs(8'h10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Hold Value", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            load_value = 8'h55;
            @(negedge clk);
            load = 0;
            shift_enable = 0;
            repeat(3) @(negedge clk);

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Load Priority Over Shift", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            load_value = 8'hFF;
            shift_enable = 1;
            @(negedge clk);
            load = 0;
            shift_enable = 0;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Shift Out MSB", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            load_value = 8'h80;
            @(negedge clk);
            load = 0;
            shift_enable = 1;
            @(negedge clk);
            shift_enable = 0;

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
        $display("shift_register Testbench");
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
        input [7:0] expected_data;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data)) begin
                $display("PASS");
                $display("  Outputs: data=%h",
                         data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h",
                         expected_data);
                $display("  Got:      data=%h",
                         data);
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
        $dumpvars(0,clk, load, load_value, shift_enable, data);
    end

endmodule
