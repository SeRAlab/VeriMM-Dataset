`timescale 1ns/1ps

module shift_reg_parallel_load_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg load;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_parallel_load dut (
        .clk(clk),
        .d(d),
        .load(load),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin


            load <= 1;
            d <= 8'h00;
            @(posedge clk);
            #1;
            load <= 0;
            d <= 8'h00;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Parallel Load", test_num);
            reset_dut();

            d <= 8'hA5;
            load <= 1;
            @(posedge clk);
            #1;
            load <= 0;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Single Shift Left", test_num);
            reset_dut();


            d <= 8'h01;
            load <= 1;
            @(posedge clk);
            #1;


            load <= 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Multiple Shifts Left (4 times)", test_num);
            reset_dut();


            d <= 8'h0F;
            load <= 1;
            @(posedge clk);
            #1;


            load <= 0;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(8'hF0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Shift out MSB", test_num);
            reset_dut();


            d <= 8'h80;
            load <= 1;
            @(posedge clk);
            #1;


            load <= 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Full Shift Out (8 times)", test_num);
            reset_dut();


            d <= 8'hFF;
            load <= 1;
            @(posedge clk);
            #1;


            load <= 0;
            repeat(8) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Load Override during Shift sequence", test_num);
            reset_dut();


            d <= 8'h55;
            load <= 1;
            @(posedge clk);
            #1;


            load <= 0;
            repeat(2) @(posedge clk);
            #1;


            d <= 8'hEE;
            load <= 1;
            @(posedge clk);
            #1;

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
        $display("shift_reg_parallel_load Testbench");
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
        $dumpvars(0,clk, d, load, q);
    end

endmodule
