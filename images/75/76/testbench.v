`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [99:0] a;
    reg [99:0] b;
    reg cin;
    reg clk;
    reg [99:0] data;
    reg [1:0] ena;
    reg load;
    wire cout;
    wire [99:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .cin(cin),
        .clk(clk),
        .data(data),
        .ena(ena),
        .load(load),
        .cout(cout),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            cin = 0;
            data = 0;
            ena = 0;
            load = 0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            a = 100'h123456789ABCDEF;
            b = 100'h1;
            cin = 0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 100'h123456789ABCDF0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            a = 100'hFFFFFFFFFFFFFFFFFFFFFFFFF;
            b = 100'h0;
            cin = 1;

            #1;
            if (cout !== 1'b1) begin
                $display("FAIL: Immediate cout check failed");
            end
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 100'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            load = 1;
            data = 100'hAAAAAAAAAAAAAAAAAAAAAAAAA;
            a = 0; b = 0; cin = 0;
            @(posedge clk);
            load = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 100'hAAAAAAAAAAAAAAAAAAAAAAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            load = 1;
            data = (100'b1 << 99);
            @(posedge clk);
            load = 0;
            ena = 2'b10;
            a = 0; b = 0; cin = 0;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 100'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            load = 1;
            data = 100'h1;
            @(posedge clk);
            load = 0;
            ena = 2'b01;
            a = 0; b = 0; cin = 0;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, (100'b1 << 99));
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            load = 1;
            data = 100'h5555555555555555555555555;
            @(posedge clk);
            load = 0;

            a = 100'hAAAAAAAAAAAAAAAAAAAAAAAAA;
            b = 0; cin = 0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 100'hFFFFFFFFFFFFFFFFFFFFFFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_cout;
        input [99:0] expected_q;
        begin
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, q=%h",
                         cout, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, q=%h",
                         expected_cout, expected_q);
                $display("  Got:      cout=%b, q=%h",
                         cout, q);
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
        $dumpvars(0,a, b, cin, clk, data, ena, load, cout, q);
    end

endmodule
