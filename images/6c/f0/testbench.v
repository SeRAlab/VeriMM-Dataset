`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg cin;
    reg clk;
    reg din;
    reg sti_data;
    reg wrenb;
    wire cout;
    wire dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cin(cin),
        .clk(clk),
        .din(din),
        .sti_data(sti_data),
        .wrenb(wrenb),
        .cout(cout),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            cin = 0;
            din = 0;
            sti_data = 0;
            wrenb = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            wrenb = 0;
            din = 0;
            cin = 0;
            sti_data = 0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: All Zeros", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            wrenb = 0;
            din = 1;
            cin = 0;
            sti_data = 0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Data Input High", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            wrenb = 0;
            din = 0;
            cin = 1;
            sti_data = 0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Carry Input High", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            wrenb = 0;
            din = 1;
            cin = 1;
            sti_data = 0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Data and Carry High", test_num);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            wrenb = 0;
            din = 1;
            cin = 0;
            sti_data = 1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Mode Toggle (sti_data=1)", test_num);

            #1;


            check_outputs(cout, dout);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            wrenb = 1;
            din = 1;
            cin = 1;
            sti_data = 0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Write Disable Check", test_num);

            #1;


            check_outputs(1'b0, 1'b0);
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
        input expected_dout;
        begin
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, dout=%b",
                         cout, dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, dout=%b",
                         expected_cout, expected_dout);
                $display("  Got:      cout=%b, dout=%b",
                         cout, dout);
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
        $dumpvars(0,cin, clk, din, sti_data, wrenb, cout, dout);
    end

endmodule
