`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg resetn;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .resetn(resetn),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            resetn = 0;
            @(negedge clk);
            resetn = 1;

            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Synchronous Reset Check");
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Single bit shift");
            reset_dut();
            data_in = 8'h01;
            @(negedge clk);

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Test Case 003: Fill register (8 bits of 1)");
            reset_dut();
            data_in = 8'h01;
            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
            end
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        reg [7:0] pattern;
        integer i;
        begin
            test_num = 4;
            $display("Test Case 004: Pattern Shift (0xA6)");
            reset_dut();
            pattern = 8'hA6;

            for (i = 7; i >= 0; i = i - 1) begin
                data_in[0] = pattern[i];
                @(negedge clk);
            end
            #1;

            check_outputs(8'hA6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Overflow (Shift 9 times)");
            reset_dut();


            data_in = 8'h01;
            @(negedge clk);


            data_in = 8'h00;
            repeat(8) @(negedge clk);


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Mid-operation Reset");
            reset_dut();


            data_in = 8'h01;
            repeat(4) @(negedge clk);


            @(negedge clk);
            resetn = 0;
            @(negedge clk);
            resetn = 1;

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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data_in, resetn, q);
    end

endmodule
