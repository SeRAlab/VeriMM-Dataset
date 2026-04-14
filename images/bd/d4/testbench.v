`timescale 1ns/1ps

module ShiftRegister_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg rst_n;
    reg serial_in;
    reg shift;
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
        .rst_n(rst_n),
        .serial_in(serial_in),
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
            rst_n = 0;
            load = 0;
            shift = 0;
            data_in = 8'b0;
            serial_in = 0;
            @(posedge clk);
            #1 rst_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Parallel Load 0xA5", test_num);
            reset_dut();
            @(negedge clk);
            data_in = 8'hA5;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Serial Shift Left", test_num);
            reset_dut();


            @(negedge clk);
            data_in = 8'h01;
            load = 1;
            @(posedge clk);
            #1 load = 0;


            @(negedge clk);
            shift = 1;
            serial_in = 1;
            @(posedge clk);


            @(negedge clk);
            serial_in = 1;
            @(posedge clk);

            #1 shift = 0;
            #1;

            check_outputs(8'h07);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load Priority Check", test_num);
            reset_dut();

            @(negedge clk);
            data_in = 8'hCC;
            load = 1;
            shift = 1;
            serial_in = 1;
            @(posedge clk);

            #1;
            load = 0;
            shift = 0;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Hold State Verification", test_num);
            reset_dut();


            @(negedge clk);
            data_in = 8'h55;
            load = 1;
            @(posedge clk);


            #1 load = 0;
            shift = 0;


            repeat(2) @(posedge clk);

            #1 #1;
 check_outputs(8'h55);
        end
        endtask

    task testcase006;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Full 8-bit Serial Fill", test_num);
            reset_dut();

            pattern = 8'b1010_1010;
            @(negedge clk);
            shift = 1;

            for (i = 0; i < 8; i = i + 1) begin
                serial_in = pattern[7-i];
                @(posedge clk);
                #1;
            end

            shift = 0;
            #1;

            check_outputs(8'hAA);
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
        $dumpvars(0,clk, data_in, load, rst_n, serial_in, shift, data_out);
    end

endmodule
