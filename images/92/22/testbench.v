`timescale 1ns/1ps

module register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg load;
    reg [7:0] load_val;
    reg reset;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register dut (
        .clk(clk),
        .enable(enable),
        .load(load),
        .load_val(load_val),
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
        enable = 0;
        load = 0;
        load_val = 8'h00;
        @(negedge clk);
        reset = 0;
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        @(negedge clk);
        enable = 1;
        load = 1;
        load_val = 8'hA5;
        @(negedge clk);
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        @(negedge clk);
        enable = 1;
        load = 1;
        load_val = 8'h11;
        @(negedge clk);

        enable = 0;
        load = 1;
        load_val = 8'hEE;
        @(negedge clk);

        #1;


        check_outputs(8'h11);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();

        @(negedge clk);
        enable = 1;
        load = 1;
        load_val = 8'h33;
        @(negedge clk);

        enable = 1;
        load = 0;
        load_val = 8'hCC;
        @(negedge clk);

        #1;


        check_outputs(8'h33);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();

        @(negedge clk);
        enable = 1;
        load = 1;
        load_val = 8'hFF;
        @(negedge clk);

        reset = 1;
        enable = 1;
        load = 1;
        load_val = 8'hAA;
        @(negedge clk);
        reset = 0;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        @(negedge clk);
        enable = 1;
        load = 1;
        load_val = 8'h01;
        @(negedge clk);
        load_val = 8'h02;
        @(negedge clk);
        load_val = 8'h04;
        @(negedge clk);
        load_val = 8'h08;
        @(negedge clk);
        #1;

        check_outputs(8'h08);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        @(negedge clk);
        enable = 1;
        load = 1;
        load_val = 8'h55;
        @(negedge clk);
        enable = 0;
        load = 0;
        load_val = 8'hAA;
        @(negedge clk);
        @(negedge clk);
        #1;

        check_outputs(8'h55);
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
        $dumpvars(0,clk, enable, load, load_val, reset, q);
    end

endmodule
