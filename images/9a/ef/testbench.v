`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] LD;
    reg clk;
    reg dir;
    reg load;
    reg rstn;
    wire cout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .LD(LD),
        .clk(clk),
        .dir(dir),
        .load(load),
        .rstn(rstn),
        .cout(cout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rstn = 0;
            load = 0;
            dir = 0;
            LD = 0;
            @(posedge clk);
            #2 rstn = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load 0x01 and Check LSB (dir=0)", test_num);
            reset_dut();
            LD = 8'h01;
            load = 1;
            dir = 0;
            @(posedge clk);
            #1 load = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load 0x80 and Check MSB (dir=1)", test_num);
            reset_dut();
            LD = 8'h80;
            load = 1;
            dir = 1;
            @(posedge clk);
            #1 load = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift Left (0x01 -> 0x02)", test_num);
            reset_dut();
            LD = 8'h01;
            load = 1;
            dir = 0;
            @(posedge clk);
            #1 load = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift Right (0x80 -> 0x40)", test_num);
            reset_dut();
            LD = 8'h80;
            load = 1;
            dir = 1;
            @(posedge clk);
            #1 load = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Left Shifts (0x03 -> 0x0C)", test_num);
            reset_dut();
            LD = 8'h03;
            load = 1;
            dir = 0;
            @(posedge clk);
            #1 load = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load Priority Over Shift", test_num);
            reset_dut();
            LD = 8'hFF;
            load = 1;
            dir = 0;
            @(posedge clk);
            #1 LD = 8'hAA;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            dir = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Direction Mode Toggle", test_num);
            reset_dut();
            LD = 8'h81;
            load = 1;
            dir = 0;
            @(posedge clk);
            #1 load = 0;

            dir = 1;
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift Left into zeros", test_num);
            reset_dut();
            LD = 8'hFF;
            load = 1;
            dir = 0;
            @(posedge clk);
            #1 load = 0;
            repeat(8) @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
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
        testcase008();
        testcase009();
        
        
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
        begin
            if (expected_cout === (expected_cout ^ cout ^ expected_cout)) begin
                $display("PASS");
                $display("  Outputs: cout=%b",
                         cout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b",
                         expected_cout);
                $display("  Got:      cout=%b",
                         cout);
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
        $dumpvars(0,LD, clk, dir, load, rstn, cout);
    end

endmodule
