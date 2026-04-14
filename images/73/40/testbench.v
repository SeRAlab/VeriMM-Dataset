`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rstn;
    reg serial_in;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .rstn(rstn),
        .serial_in(serial_in),
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
            rstn = 0;
            serial_in = 0;
            @(negedge clk);
            rstn = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset and check initial state (Should be 0x00)", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift in 8 ones", test_num);
            reset_dut();
            serial_in = 1;
            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
            end
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift in pattern 0x55 (01010101)", test_num);
            reset_dut();
            pattern = 8'h55;
            for (i = 0; i < 8; i = i + 1) begin
                serial_in = pattern[7-i];
                @(negedge clk);
            end
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift in pattern 0xAA (10101010)", test_num);
            reset_dut();
            pattern = 8'hAA;
            for (i = 0; i < 8; i = i + 1) begin
                serial_in = pattern[7-i];
                @(negedge clk);
            end
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Over-shifting 12 bits (Check overflow logic)", test_num);
            reset_dut();


            serial_in = 1;
            repeat(4) @(negedge clk);


            serial_in = 0; repeat(2) @(negedge clk);
            serial_in = 1; repeat(2) @(negedge clk);
            serial_in = 0; repeat(2) @(negedge clk);
            serial_in = 1; repeat(2) @(negedge clk);

            #1;


            check_outputs(8'h33);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Partial shift then synchronous reset", test_num);
            reset_dut();

            serial_in = 1;
            repeat(4) @(negedge clk);

            @(negedge clk);
            rstn = 0;
            @(negedge clk);
            rstn = 1;

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
        $dumpvars(0,clk, rstn, serial_in, data_out);
    end

endmodule
