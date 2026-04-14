`timescale 1ns/1ps

module shift_register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] parallel_in;
    reg rst;
    reg serial_in;
    reg shift;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_8bit dut (
        .clk(clk),
        .parallel_in(parallel_in),
        .rst(rst),
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
            rst = 1;
            shift = 0;
            parallel_in = 0;
            serial_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Parallel Load Verification (0xAA)", test_num);
            reset_dut();
            parallel_in = 8'hAA;
            shift = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Parallel Load Verification (0x55)", test_num);
            reset_dut();
            parallel_in = 8'h55;
            shift = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift Right Single Cycle (Input 1)", test_num);
            reset_dut();

            parallel_in = 8'h00;
            shift = 0;
            @(posedge clk);
            #1;

            serial_in = 1;
            shift = 1;
            @(posedge clk);

            #1 #1;
 check_outputs(8'h80);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift Right Multiple Cycles", test_num);
            reset_dut();

            parallel_in = 8'hFF;
            shift = 0;
            @(posedge clk);
            #1;

            serial_in = 0;
            shift = 1;
            repeat(4) @(posedge clk);

            #1 #1;
 check_outputs(8'h0F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Full Shift Out (8 cycles)", test_num);
            reset_dut();

            parallel_in = 8'hAA;
            shift = 0;
            @(posedge clk);
            #1;

            serial_in = 1;
            shift = 1;
            repeat(8) @(posedge clk);

            #1 #1;
 check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Complex Sequence (Load -> Shift -> Load)", test_num);
            reset_dut();

            parallel_in = 8'h55;
            shift = 0;
            @(posedge clk);
            #1;


            serial_in = 0;
            shift = 1;
            repeat(2) @(posedge clk);
            #1;

            parallel_in = 8'hEE;
            shift = 0;
            @(posedge clk);
            #1 #1;
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
        $display("shift_register_8bit Testbench");
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
        $dumpvars(0,clk, parallel_in, rst, serial_in, shift, data_out);
    end

endmodule
