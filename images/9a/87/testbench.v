`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] ambient_light;
    reg [2:0] brightness_level;
    reg clk;
    reg enable;
    wire dim_down;
    wire dim_up;
    wire [11:0] light_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ambient_light(ambient_light),
        .brightness_level(brightness_level),
        .clk(clk),
        .enable(enable),
        .dim_down(dim_down),
        .dim_up(dim_up),
        .light_output(light_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            ambient_light = 12'h0;
            brightness_level = 3'b000;

            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: System Disabled Check", test_num);
            reset_dut();


            ambient_light = 12'hFFF;
            brightness_level = 3'b111;
            repeat(10) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max Brightness (Full Setting, No Ambient)", test_num);
            reset_dut();

            enable = 1;
            ambient_light = 12'h000;
            brightness_level = 3'b111;



            repeat(100) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 12'hFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Min Brightness (Low Setting, High Ambient)", test_num);
            reset_dut();

            enable = 1;
            ambient_light = 12'hFFF;
            brightness_level = 3'b000;

            repeat(100) @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 12'h000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid-level Brightness Control", test_num);
            reset_dut();

            enable = 1;
            ambient_light = 12'h000;
            brightness_level = 3'b100;

            repeat(100) @(posedge clk);




            #1;





            check_outputs(1'b0, 1'b0, 12'h924);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Gradual Dim Down Response", test_num);
            reset_dut();


            enable = 1;
            ambient_light = 12'h200;
            brightness_level = 3'b110;
            repeat(50) @(posedge clk);


            ambient_light = 12'hE00;



            repeat(100) @(posedge clk);



            #1;




            check_outputs(1'b0, 1'b0, 12'h1B6);
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
        input expected_dim_down;
        input expected_dim_up;
        input [11:0] expected_light_output;
        begin
            if (expected_dim_down === (expected_dim_down ^ dim_down ^ expected_dim_down) &&
                expected_dim_up === (expected_dim_up ^ dim_up ^ expected_dim_up) &&
                expected_light_output === (expected_light_output ^ light_output ^ expected_light_output)) begin
                $display("PASS");
                $display("  Outputs: dim_down=%b, dim_up=%b, light_output=%h",
                         dim_down, dim_up, light_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dim_down=%b, dim_up=%b, light_output=%h",
                         expected_dim_down, expected_dim_up, expected_light_output);
                $display("  Got:      dim_down=%b, dim_up=%b, light_output=%h",
                         dim_down, dim_up, light_output);
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
        $dumpvars(0,ambient_light, brightness_level, clk, enable, dim_down, dim_up, light_output);
    end

endmodule
