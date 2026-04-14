`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg reset;
    reg shift_in;
    wire [7:0] q;
    wire shift_out;

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
        .shift_in(shift_in),
        .q(q),
        .shift_out(shift_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            load = 0;
            data_in = 8'b0;
            shift_in = 0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Parallel Load...");
            test_num = test_num + 1;
            reset_dut();

            @(negedge clk);
            load = 1;
            data_in = 8'hA5;
            @(negedge clk);
            load = 0;


            #1;



            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Shift (0)...");
            test_num = test_num + 1;
            reset_dut();


            @(negedge clk);
            load = 1;
            data_in = 8'h01;
            @(negedge clk);
            load = 0;


            shift_in = 0;
            @(negedge clk);


            #1;



            check_outputs(8'h02, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Single Shift (1)...");
            test_num = test_num + 1;
            reset_dut();


            @(negedge clk);
            load = 1;
            data_in = 8'h01;
            @(negedge clk);
            load = 0;


            shift_in = 1;
            @(negedge clk);


            #1;



            check_outputs(8'h03, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Running testcase004: 8-bit Serial Shift-in...");
            test_num = test_num + 1;
            reset_dut();

            @(negedge clk);
            shift_in = 1;

            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
            end


            #1;



            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Shift Out Propagation...");
            test_num = test_num + 1;
            reset_dut();


            @(negedge clk);
            load = 1;
            data_in = 8'h80;
            @(negedge clk);
            load = 0;



            shift_in = 0;
            @(negedge clk);


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Reset Priority...");
            test_num = test_num + 1;
            reset_dut();

            @(negedge clk);
            reset = 1;
            load = 1;
            data_in = 8'hFF;
            @(negedge clk);
            reset = 0;
            load = 0;


            #1;



            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Load-Shift-Load Sequence...");
            test_num = test_num + 1;
            reset_dut();


            @(negedge clk);
            load = 1;
            data_in = 8'hAA;
            @(negedge clk);
            load = 0;


            shift_in = 1;
            @(negedge clk);
            @(negedge clk);





            @(negedge clk);
            load = 1;
            data_in = 8'h55;
            @(negedge clk);
            load = 0;


            #1;



            check_outputs(8'h55, 1'b0);
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
        input [7:0] expected_q;
        input expected_shift_out;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_shift_out === (expected_shift_out ^ shift_out ^ expected_shift_out)) begin
                $display("PASS");
                $display("  Outputs: q=%h, shift_out=%b",
                         q, shift_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, shift_out=%b",
                         expected_q, expected_shift_out);
                $display("  Got:      q=%h, shift_out=%b",
                         q, shift_out);
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
        $dumpvars(0,clk, data_in, load, reset, shift_in, q, shift_out);
    end

endmodule
