`timescale 1ns/1ps

module register_adder_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] D;
    reg clk;
    reg load;
    reg rst;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_adder dut (
        .D(D),
        .clk(clk),
        .load(load),
        .rst(rst),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            D = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Reset and Load", test_num);
            reset_dut();

            D = 8'hA5;
            load = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Addition", test_num);
            reset_dut();


            D = 8'd10;
            load = 1;
            @(posedge clk);
            #1;


            D = 8'd15;
            load = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd25);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential Accumulation", test_num);
            reset_dut();


            D = 8'd20;
            load = 1;
            @(posedge clk);
            #1;


            D = 8'd5;
            load = 0;
            @(posedge clk);
            #1;


            D = 8'd10;
            load = 0;
            @(posedge clk);
            #1;


            D = 8'd2;
            load = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd37);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overflow Handling", test_num);
            reset_dut();


            D = 8'hFF;
            load = 1;
            @(posedge clk);
            #1;


            D = 8'h02;
            load = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load Override", test_num);
            reset_dut();


            D = 8'd50;
            load = 1;
            @(posedge clk);
            #1;


            D = 8'd10;
            load = 0;
            @(posedge clk);
            #1;


            D = 8'd100;
            load = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'd100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Add Zero", test_num);
            reset_dut();

            D = 8'h55;
            load = 1;
            @(posedge clk);
            #1;

            D = 8'h00;
            load = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Priority", test_num);
            reset_dut();


            D = 8'hFF;
            load = 1;
            @(posedge clk);
            #1;


            rst = 1;
            D = 8'hAA;
            load = 1;
            @(posedge clk);
            #1;
            rst = 0;

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
        $display("register_adder Testbench");
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
        input [7:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, clk, load, rst, Q);
    end

endmodule
