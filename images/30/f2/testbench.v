`timescale 1ns/1ps

module ShiftRegister_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ShiftRegister dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
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
            data_in = 8'h00;
            @(negedge clk);
            load = 0;
            data_in = 8'h00;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Load", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            data_in = 8'hA5;
            @(negedge clk);
            load = 0;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Right 1 Bit", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            data_in = 8'h02;
            @(negedge clk);
            load = 0;
            @(negedge clk);

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Right 4 Bits", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            data_in = 8'hF0;
            @(negedge clk);
            load = 0;


            repeat(4) @(negedge clk);

            #1;


            check_outputs(8'h0F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift All Bits Out", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            data_in = 8'h80;
            @(negedge clk);
            load = 0;


            repeat(8) @(negedge clk);

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB to 0 Transition", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            data_in = 8'hFF;
            @(negedge clk);
            load = 0;
            @(negedge clk);

            #1;


            check_outputs(8'h7F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load Override", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            data_in = 8'hAA;
            @(negedge clk);
            load = 0;
            @(negedge clk);

            @(negedge clk);
            load = 1;
            data_in = 8'hEE;
            @(negedge clk);
            load = 0;

            #1;


            check_outputs(8'hEE);
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, load, data_out);
    end

endmodule
