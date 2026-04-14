`timescale 1ns/1ps

module ShiftRegister_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg load_enable;
    reg shift_enable;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ShiftRegister dut (
        .clk(clk),
        .data_in(data_in),
        .load_enable(load_enable),
        .shift_enable(shift_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load_enable = 1;
            shift_enable = 0;
            data_in = 16'h0000;
            @(posedge clk);
            #1;
            load_enable = 0;
            data_in = 16'h0000;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Parallel Load", test_num);
            reset_dut();

            data_in = 16'hA5A5;
            load_enable = 1;
            @(posedge clk);
            #1;
            load_enable = 0;

            #1;


            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Shift Left", test_num);
            reset_dut();


            data_in = 16'h0001;
            load_enable = 1;
            @(posedge clk);
            #1;
            load_enable = 0;


            shift_enable = 1;
            @(posedge clk);
            #1;
            shift_enable = 0;

            #1;


            check_outputs(16'h0002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Shifts (8 cycles)", test_num);
            reset_dut();


            data_in = 16'h00FF;
            load_enable = 1;
            @(posedge clk);
            #1;
            load_enable = 0;


            shift_enable = 1;
            repeat(8) @(posedge clk);
            #1;
            shift_enable = 0;

            #1;


            check_outputs(16'hFF00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: MSB Shift Out", test_num);
            reset_dut();


            data_in = 16'h8000;
            load_enable = 1;
            @(posedge clk);
            #1;
            load_enable = 0;


            shift_enable = 1;
            @(posedge clk);
            #1;
            shift_enable = 0;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load Priority Over Shift", test_num);
            reset_dut();

            data_in = 16'h1234;
            load_enable = 1;
            shift_enable = 1;
            @(posedge clk);
            #1;
            load_enable = 0;
            shift_enable = 0;

            #1;


            check_outputs(16'h1234);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Persistence (Enable = 0)", test_num);
            reset_dut();


            data_in = 16'hF0F0;
            load_enable = 1;
            @(posedge clk);
            #1;
            load_enable = 0;


            shift_enable = 0;
            data_in = 16'hFFFF;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(16'hF0F0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift Full Register Out", test_num);
            reset_dut();

            data_in = 16'hFFFF;
            load_enable = 1;
            @(posedge clk);
            #1;
            load_enable = 0;

            shift_enable = 1;
            repeat(16) @(posedge clk);
            #1;
            shift_enable = 0;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ShiftRegister Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [15:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, load_enable, shift_enable, data_out);
    end

endmodule
