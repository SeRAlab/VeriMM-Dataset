`timescale 1ns/1ps

module iir_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] x_n;
    wire [15:0] y_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    iir_filter dut (
        .clk(clk),
        .rst(rst),
        .x_n(x_n),
        .y_n(y_n)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            x_n = 16'h0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Unit Impulse Response", test_num);
            reset_dut();
            x_n = 16'h0001; @(posedge clk);
            x_n = 16'h0000; @(posedge clk);
            x_n = 16'h0000; @(posedge clk);


            #1;



            check_outputs(16'h0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Step Response", test_num);
            reset_dut();
            x_n = 16'h0001;
            repeat(3) @(posedge clk);


            #1;



            check_outputs(16'h0003);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: State Delay (x[n-2] check)", test_num);
            reset_dut();
            x_n = 16'h000A; @(posedge clk);
            x_n = 16'h0000; @(posedge clk);
            x_n = 16'h0000; @(posedge clk);

            #1;


            check_outputs(16'h000A);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Large Value Input", test_num);
            reset_dut();
            x_n = 16'h1000; @(posedge clk);
            x_n = 16'h1000; @(posedge clk);
            x_n = 16'h1000; @(posedge clk);
            #1;

            check_outputs(16'h3000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("iir_filter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [15:0] expected_y_n;
        begin
            if (expected_y_n === (expected_y_n ^ y_n ^ expected_y_n)) begin
                $display("PASS");
                $display("  Outputs: y_n=%h",
                         y_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y_n=%h",
                         expected_y_n);
                $display("  Got:      y_n=%h",
                         y_n);
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
        $dumpvars(0,clk, rst, x_n, y_n);
    end

endmodule
