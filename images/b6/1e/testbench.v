`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg cin;
    reg clk;
    reg [7:0] data;
    reg load;
    wire cout;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cin(cin),
        .clk(clk),
        .data(data),
        .load(load),
        .cout(cout),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            cin = 0;
            load = 1;
            data = 8'h00;
            @(posedge clk);
            #1;
            load = 0;
            data = 8'h00;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Load", test_num);
            reset_dut();

            data = 8'hA5;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;

            #1;


            check_outputs(1'b0, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Increment", test_num);
            reset_dut();


            data = 8'h10;
            load = 1;
            @(posedge clk);
            #1;


            load = 0;
            cin = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'h11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rollover and Cout", test_num);
            reset_dut();


            data = 8'hFF;
            load = 1;
            @(posedge clk);
            #1;


            load = 0;
            cin = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Cin = 0 No Change", test_num);
            reset_dut();


            data = 8'h55;
            load = 1;
            @(posedge clk);
            #1;


            load = 0;
            cin = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Priority", test_num);
            reset_dut();


            data = 8'h20;
            load = 1;
            @(posedge clk);
            #1;


            data = 8'hEE;
            load = 1;
            cin = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 8'hEE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Increments", test_num);
            reset_dut();


            load = 1;
            data = 8'h00;
            @(posedge clk);
            #1;


            load = 0;
            cin = 1;
            repeat(5) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'h05);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Cout Check at 0xFE", test_num);
            reset_dut();


            data = 8'hFE;
            load = 1;
            @(posedge clk);
            #1;


            load = 0;
            cin = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 8'hFF);
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
        input expected_cout;
        input [7:0] expected_out;
        begin
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, out=%h",
                         cout, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, out=%h",
                         expected_cout, expected_out);
                $display("  Got:      cout=%b, out=%h",
                         cout, out);
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
        $dumpvars(0,cin, clk, data, load, cout, out);
    end

endmodule
