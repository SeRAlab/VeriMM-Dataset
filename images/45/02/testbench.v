`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg clk;
    reg timer;
    wire [1:0] light;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .areset(areset),
        .clk(clk),
        .timer(timer),
        .light(light)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            timer = 0;
            areset = 1;
            #15;
            areset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Checking Reset State", test_num);
            reset_dut();

            #1 #1;
 check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Green to Yellow Transition", test_num);
            reset_dut();
            @(posedge clk);
            timer = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Yellow to Red Transition", test_num);
            reset_dut();
            @(posedge clk);
            timer = 1;
            @(posedge clk);
            timer = 1;
            @(posedge clk);
            #2 #1;
 check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Red to Green Transition", test_num);
            reset_dut();
            @(posedge clk);
            timer = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #2 #1;
 check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Hold Green State", test_num);
            reset_dut();
            timer = 0;
            repeat(3) @(posedge clk);
            #2 #1;
 check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Hold Yellow State", test_num);
            reset_dut();
            @(posedge clk);
            timer = 1;
            @(posedge clk);
            timer = 0;
            repeat(3) @(posedge clk);
            #2 #1;
 check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Hold Red State", test_num);
            reset_dut();
            @(posedge clk);
            timer = 1;
            @(posedge clk);
            @(posedge clk);
            timer = 0;
            repeat(3) @(posedge clk);
            #2 #1;
 check_outputs(2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Async Reset from Red", test_num);
            reset_dut();
            @(posedge clk);
            timer = 1;
            @(posedge clk);
            @(posedge clk);
            #2;
            areset = 1;
            #1;
            #1;

            check_outputs(2'b00);
            areset = 0;
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
        input [1:0] expected_light;
        begin
            if (expected_light === (expected_light ^ light ^ expected_light)) begin
                $display("PASS");
                $display("  Outputs: light=%h",
                         light);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: light=%h",
                         expected_light);
                $display("  Got:      light=%h",
                         light);
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
        $dumpvars(0,areset, clk, timer, light);
    end

endmodule
