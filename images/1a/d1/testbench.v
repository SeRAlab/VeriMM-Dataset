`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg load;
    reg shift_en;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .shift_en(shift_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 4'b0000;
            load = 1;
            shift_en = 0;
            @(posedge clk);
            #1;
            load = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Parallel Load 4'hA", test_num);
            reset_dut();
            data_in = 4'hA;
            load = 1;
            shift_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Shift Left (4'h1 -> 4'h2)", test_num);
            reset_dut();

            data_in = 4'h1;
            load = 1;
            @(posedge clk);
            #1;

            load = 0;
            shift_en = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Three Shifts Left (4'h1 -> 4'h8)", test_num);
            reset_dut();

            data_in = 4'h1;
            load = 1;
            @(posedge clk);
            #1;

            load = 0;
            shift_en = 1;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Shift Enable Low (4'h7 stays 4'h7)", test_num);
            reset_dut();

            data_in = 4'h7;
            load = 1;
            @(posedge clk);
            #1;

            load = 0;
            shift_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Load Priority Over Shift Enable", test_num);
            reset_dut();

            data_in = 4'hC;
            load = 1;
            shift_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hC);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Shift Most Significant Bit Out", test_num);
            reset_dut();

            data_in = 4'h8;
            load = 1;
            @(posedge clk);
            #1;

            load = 0;
            shift_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0);
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
        input [3:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, load, shift_en, data_out);
    end

endmodule
