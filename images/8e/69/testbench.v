`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [99:0] data;
    reg [1:0] ena;
    reg load;
    wire [99:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .ena(ena),
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
            @(posedge clk);
            load = 1;
            data = 100'd0;
            ena = 2'b00;
            @(posedge clk);
            load = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Load and No Change (ena=00)", test_num);

            @(posedge clk);
            load = 1;
            data = 100'h5555555555555555555555555;
            @(posedge clk);
            load = 0;
            ena = 2'b00;
            @(posedge clk);

            #1;


            check_outputs(100'h5555555555555555555555555);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Rotate Right by 1 (ena=01)", test_num);

            @(posedge clk);
            load = 1;
            data = 100'h1;
            @(posedge clk);
            load = 0;
            ena = 2'b01;
            @(posedge clk);



            #1;




            check_outputs(100'h8000000000000000000000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Rotate Left by 1 (ena=10)", test_num);

            @(posedge clk);
            load = 1;
            data = 100'h8000000000000000000000000;
            @(posedge clk);
            load = 0;
            ena = 2'b10;
            @(posedge clk);

            #1;


            check_outputs(100'h1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Rotate Left by 2 (ena=11)", test_num);

            @(posedge clk);
            load = 1;
            data = 100'h3;
            @(posedge clk);
            load = 0;
            ena = 2'b11;
            @(posedge clk);


            #1;



            check_outputs(100'hc);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Multi-cycle Rotate Right (ena=01)", test_num);

            @(posedge clk);
            load = 1;
            data = 100'hF;
            @(posedge clk);
            load = 0;
            ena = 2'b01;
            repeat(4) @(posedge clk);






            #1;







            check_outputs(100'hF000000000000000000000000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Rotate Left 2 Wrap Check", test_num);

            @(posedge clk);
            load = 1;
            data = 100'hC000000000000000000000000;
            @(posedge clk);
            load = 0;
            ena = 2'b11;
            @(posedge clk);


            #1;



            check_outputs(100'h3);
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
        input [99:0] expected_q;
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
        $dumpvars(0,clk, data, ena, load, q);
    end

endmodule
