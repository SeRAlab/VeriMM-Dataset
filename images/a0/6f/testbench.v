`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data_in;
    reg load;
    reg rst_n;
    reg shift;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .rst_n(rst_n),
        .shift(shift),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            rst_n = 0;
            load = 0;
            shift = 0;
            data_in = 0;
            @(posedge clk);
            rst_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous Reset", test_num);
            reset_dut();

            @(posedge clk);
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Parallel Load 5'b10101", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            data_in = 5'b10101;
            @(posedge clk);
            load = 0;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Shift Left (00001 -> 00010)", test_num);
            reset_dut();

            @(posedge clk);
            load = 1;
            data_in = 5'b00001;
            @(posedge clk);
            load = 0;
            shift = 1;
            @(posedge clk);
            shift = 0;
            #1;

            check_outputs(5'b00010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority Check (Load and Shift both high)", test_num);
            reset_dut();

            @(posedge clk);
            load = 1;
            shift = 1;
            data_in = 5'b11011;
            @(posedge clk);
            load = 0;
            shift = 0;
            #1;

            check_outputs(5'b11011);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift Left 3 times (00011 -> 11000)", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            data_in = 5'b00011;
            @(posedge clk);
            load = 0;
            shift = 1;
            repeat(3) @(posedge clk);
            shift = 0;
            #1;

            check_outputs(5'b11000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift MSB out (10000 -> 00000)", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            data_in = 5'b10000;
            @(posedge clk);
            load = 0;
            shift = 1;
            @(posedge clk);
            shift = 0;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift while data_in changes", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            data_in = 5'b00101;
            @(posedge clk);
            load = 0;
            shift = 1;
            data_in = 5'b11111;
            @(posedge clk);
            shift = 0;
            #1;

            check_outputs(5'b01010);
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
        input [4:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, load, rst_n, shift, data_out);
    end

endmodule
