`timescale 1ns/1ps

module jt51_timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr_flag;
    reg clr_run;
    reg load;
    reg rst;
    reg set_run;
    reg [9:0] start_value;
    wire flag;
    wire overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    jt51_timer dut (
        .clk(clk),
        .clr_flag(clr_flag),
        .clr_run(clr_run),
        .load(load),
        .rst(rst),
        .set_run(set_run),
        .start_value(start_value),
        .flag(flag),
        .overflow(overflow)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            clr_flag = 0;
            clr_run = 0;
            load = 0;
            set_run = 0;
            start_value = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Load Value without Running", test_num);
            reset_dut();

            start_value = 10'h3FF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Simple Overflow", test_num);
            reset_dut();


            start_value = 10'h3FE;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;


            set_run = 1;
            @(posedge clk);
            #1;
            set_run = 0;



            repeat(50) begin
                @(posedge clk);
                if (flag == 1'b1) break;
            end
            #1;


            #1;



            check_outputs(1'b1, overflow);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Manual Flag Clear", test_num);
            reset_dut();


            start_value = 10'h3FF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            set_run = 1;


            wait(flag == 1'b1);
            @(posedge clk);
            #1;


            clr_flag = 1;
            @(posedge clk);
            #1;
            clr_flag = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Stop Timer Execution", test_num);
            reset_dut();


            start_value = 10'h000;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;


            set_run = 1;
            @(posedge clk);
            #1;
            set_run = 0;


            repeat(10) @(posedge clk);
            clr_run = 1;
            @(posedge clk);
            #1;
            clr_run = 0;


            repeat(100) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Multiple Overflows", test_num);
            reset_dut();

            start_value = 10'h3F0;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            set_run = 1;


            wait(flag == 1'b1);
            @(posedge clk);
            #1;
            clr_flag = 1;
            @(posedge clk);
            #1;
            clr_flag = 0;


            repeat(100) begin
                @(posedge clk);
                if (flag == 1'b1) break;
            end
            #1;

            #1;


            check_outputs(1'b1, overflow);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("jt51_timer Testbench");
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
        input expected_flag;
        input expected_overflow;
        begin
            if (expected_flag === (expected_flag ^ flag ^ expected_flag) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow)) begin
                $display("PASS");
                $display("  Outputs: flag=%b, overflow=%b",
                         flag, overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: flag=%b, overflow=%b",
                         expected_flag, expected_overflow);
                $display("  Got:      flag=%b, overflow=%b",
                         flag, overflow);
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
        $dumpvars(0,clk, clr_flag, clr_run, load, rst, set_run, start_value, flag, overflow);
    end

endmodule
