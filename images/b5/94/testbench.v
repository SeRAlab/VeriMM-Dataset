`timescale 1ns/1ps

module bidirectional_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg en;
    reg rst;
    reg shift_left;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bidirectional_shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .en(en),
        .rst(rst),
        .shift_left(shift_left),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 0;
            en = 0;
            shift_left = 0;
            data_in = 0;
            @(posedge clk);
            #1 rst = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Reset and Idle State");
            test_num = test_num + 1;
            reset_dut();

            repeat (5) @(posedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] test_pattern;
        begin
            $display("Running testcase002: Shift Left 8 bits");
            test_num = test_num + 1;
            reset_dut();
            test_pattern = 8'hAB;
            en = 1;
            shift_left = 1;

            for (i = 0; i < 8; i = i + 1) begin
                data_in = test_pattern[7-i];
                @(posedge clk);
            end

            en = 0;
            #1;

            check_outputs(8'hAB);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] pattern;
        begin
            $display("Running testcase003: Shift Right 8 bits");
            test_num = test_num + 1;
            reset_dut();
            pattern = 8'hF0;
            en = 1;
            shift_left = 0;



            for (i = 0; i < 8; i = i + 1) begin
                data_in = (i < 4) ? 0 : 1;
                @(posedge clk);
            end

            en = 0;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Enable Signal Control");
            test_num = test_num + 1;
            reset_dut();


            en = 1;
            shift_left = 1;
            data_in = 1;
            repeat (4) @(posedge clk);


            en = 0;
            data_in = 0;
            shift_left = 0;
            repeat (4) @(posedge clk);

            #1;


            check_outputs(8'h0F);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Bidirectional Operation");
            test_num = test_num + 1;
            reset_dut();


            en = 1;
            shift_left = 1;
            data_in = 1;
            repeat (4) @(posedge clk);


            shift_left = 0;
            data_in = 0;
            repeat (2) @(posedge clk);

            en = 0;
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Reset Override");
            test_num = test_num + 1;
            reset_dut();


            en = 1;
            shift_left = 1;
            data_in = 1;
            repeat (8) @(posedge clk);


            #2 rst = 0;
            @(posedge clk);
            #1 rst = 1;

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
        $display("bidirectional_shift_register Testbench");
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
        $dumpvars(0,clk, data_in, en, rst, shift_left, data_out);
    end

endmodule
