`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg load;
    reg shift_left;
    reg shift_right;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .data_out(data_out)
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
            data_in = 16'h0000;
            shift_left = 0;
            shift_right = 0;
            @(negedge clk);
            load = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Load Data");
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 16'hA5A5;
            @(negedge clk);
            load = 0;
            #1;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Shift Left (1 bit)");
            reset_dut();

            @(negedge clk);
            load = 1;
            data_in = 16'h0001;
            @(negedge clk);
            load = 0;
            shift_left = 1;
            @(negedge clk);
            shift_left = 0;
            #1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Shift Right (1 bit)");
            reset_dut();

            @(negedge clk);
            load = 1;
            data_in = 16'h8000;
            @(negedge clk);
            load = 0;
            shift_right = 1;
            @(negedge clk);
            shift_right = 0;
            #1;
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Load Priority Over Shift");
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 16'hFFFF;
            shift_left = 1;
            @(negedge clk);
            load = 0;
            shift_left = 0;
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Running testcase005: Shift Left (4 bits)");
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 16'h000F;
            @(negedge clk);
            load = 0;
            shift_left = 1;
            for(i=0; i<4; i=i+1) @(negedge clk);
            shift_left = 0;
            #1;
            #1;

            check_outputs(16'h00F0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Running testcase006: Shift Right (8 bits)");
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 16'hFF00;
            @(negedge clk);
            load = 0;
            shift_right = 1;
            for(i=0; i<8; i=i+1) @(negedge clk);
            shift_right = 0;
            #1;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase007;

        integer i;
        begin
            $display("Running testcase007: Shift Left Out (Overflow)");
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 16'h8000;
            @(negedge clk);
            load = 0;
            shift_left = 1;
            @(negedge clk);
            shift_left = 0;
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Maintain State (No control)");
            reset_dut();
            @(negedge clk);
            load = 1;
            data_in = 16'h5555;
            @(negedge clk);
            load = 0;
            shift_left = 0;
            shift_right = 0;
            repeat(5) @(negedge clk);
            #1;
            #1;

            check_outputs(16'h5555);
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
        $dumpvars(0,clk, data_in, load, shift_left, shift_right, data_out);
    end

endmodule
