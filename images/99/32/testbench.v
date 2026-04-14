`timescale 1ns/1ps

module register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg ena;
    reg reset;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register dut (
        .clk(clk),
        .data(data),
        .ena(ena),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ena = 0;
            data = 0;
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Verify Asynchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Load Data (ena=1)", test_num);
            reset_dut();
            @(negedge clk);
            ena = 1;
            data = 8'hA5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Data Retention (ena=0)", test_num);
            reset_dut();

            @(negedge clk);
            ena = 1;
            data = 8'h55;
            @(posedge clk);
            #2;

            @(negedge clk);
            ena = 0;
            data = 8'hAA;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Asynchronous Reset Priority", test_num);
            reset_dut();

            @(negedge clk);
            ena = 1;
            data = 8'hFF;
            @(posedge clk);
            #2;

            #3;
            reset = 1;
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Multiple Sequential Loads", test_num);
            reset_dut();
            @(negedge clk);
            ena = 1;
            data = 8'h01;
            @(posedge clk);
            @(negedge clk);
            data = 8'h02;
            @(posedge clk);
            @(negedge clk);
            data = 8'h04;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Toggle Enable mid-stream", test_num);
            reset_dut();
            @(negedge clk);
            ena = 1;
            data = 8'h11;
            @(posedge clk);
            @(negedge clk);
            ena = 0;
            data = 8'h22;
            @(posedge clk);
            @(negedge clk);
            ena = 1;
            data = 8'h33;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h33);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register Testbench");
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
        $dumpvars(0,clk, data, ena, reset, q);
    end

endmodule
