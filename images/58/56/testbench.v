`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg load;
    reg reset;
    reg shift;
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
        .reset(reset),
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
            $display("Resetting DUT...");
            reset = 1;
            load = 0;
            shift = 0;
            data_in = 4'b0000;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Initial Reset", test_num);
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Parallel Load 4'b1011", test_num);
            reset_dut();

            data_in = 4'b1011;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;

            #1;


            check_outputs(4'b1011);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Shift Left (from 4'b0001 to 4'b0010)", test_num);
            reset_dut();


            data_in = 4'b0001;
            load = 1;
            @(posedge clk);
            #1;


            load = 0;
            shift = 1;
            @(posedge clk);
            #1;
            shift = 0;

            #1;


            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Multiple Shift Lefts (4'b0011 -> 4'b1100)", test_num);
            reset_dut();


            data_in = 4'b0011;
            load = 1;
            @(posedge clk);
            #1;


            load = 0;
            shift = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            shift = 0;

            #1;


            check_outputs(4'b1100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Priority Check (Load should take priority over Shift)", test_num);
            reset_dut();


            data_in = 4'b0101;
            load = 1;
            @(posedge clk);
            #1;


            data_in = 4'b1111;
            load = 1;
            shift = 1;
            @(posedge clk);
            #1;



            #1;




            check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Data Retention (Idle)", test_num);
            reset_dut();


            data_in = 4'b1001;
            load = 1;
            @(posedge clk);
            #1;


            load = 0;
            shift = 0;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(4'b1001);
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
        $dumpvars(0,clk, data_in, load, reset, shift, data_out);
    end

endmodule
