`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg pixel_clk_i;
    reg pixel_valid_i;
    reg [11:0] pixel_x_i;
    reg [11:0] pixel_y_i;
    wire [9:0] led_strip_address_o;
    wire led_strip_address_valid_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pixel_clk_i(pixel_clk_i),
        .pixel_valid_i(pixel_valid_i),
        .pixel_x_i(pixel_x_i),
        .pixel_y_i(pixel_y_i),
        .led_strip_address_o(led_strip_address_o),
        .led_strip_address_valid_o(led_strip_address_valid_o)
    );
    task testcase001;

    begin
        @(posedge pixel_clk_i);
        pixel_valid_i = 1;
        pixel_x_i = 12'd0;
        pixel_y_i = Y_START;

        @(negedge pixel_clk_i);
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Start (X=0, Y=Y_START)", test_num);
        #1;

        check_outputs(10'd0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        @(posedge pixel_clk_i);
        pixel_valid_i = 1;
        pixel_x_i = 12'd0;
        pixel_y_i = Y_START + 12'd5;

        @(negedge pixel_clk_i);
        test_num = test_num + 1;
        $display("Testcase %0d: Middle of range (X=0, Y=Y_START+5)", test_num);
        #1;

        check_outputs(10'd5, 1'b1);
    end
        endtask

    task testcase003;

    begin
        @(posedge pixel_clk_i);
        pixel_valid_i = 1;
        pixel_x_i = 12'd0;
        pixel_y_i = Y_END;

        @(negedge pixel_clk_i);
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary End (X=0, Y=Y_END)", test_num);
        #1;

        check_outputs(Y_END - Y_START, 1'b1);
    end
        endtask

    task testcase004;

    begin
        @(posedge pixel_clk_i);
        pixel_valid_i = 1;
        pixel_x_i = 12'd1;
        pixel_y_i = Y_START + 12'd2;

        @(negedge pixel_clk_i);
        test_num = test_num + 1;
        $display("Testcase %0d: Invalid X (X=1, Y within range)", test_num);
        #1;

        check_outputs(10'd0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        @(posedge pixel_clk_i);
        pixel_valid_i = 1;
        pixel_x_i = 12'd0;
        pixel_y_i = Y_START - 12'd1;

        @(negedge pixel_clk_i);
        test_num = test_num + 1;
        $display("Testcase %0d: Y below range (X=0, Y=Y_START-1)", test_num);
        #1;

        check_outputs(10'd0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        @(posedge pixel_clk_i);
        pixel_valid_i = 1;
        pixel_x_i = 12'd0;
        pixel_y_i = Y_END + 12'd1;

        @(negedge pixel_clk_i);
        test_num = test_num + 1;
        $display("Testcase %0d: Y above range (X=0, Y=Y_END+1)", test_num);
        #1;

        check_outputs(10'd0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        @(posedge pixel_clk_i);
        pixel_valid_i = 0;
        pixel_x_i = 12'd0;
        pixel_y_i = Y_START + 12'd1;

        @(negedge pixel_clk_i);
        test_num = test_num + 1;
        $display("Testcase %0d: pixel_valid_i is low", test_num);
        #1;

        check_outputs(10'd0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        @(posedge pixel_clk_i);
        pixel_valid_i = 1;
        pixel_x_i = 12'd0;
        pixel_y_i = Y_START + 10'h3FF;

        @(negedge pixel_clk_i);
        test_num = test_num + 1;
        $display("Testcase %0d: Large Y offset (checking address width)", test_num);


        if ((Y_START + 10'h3FF) <= Y_END)
            #1;

            check_outputs(10'h3FF, 1'b1);
        else
            #1;

            check_outputs(10'd0, 1'b0);
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
        input [9:0] expected_led_strip_address_o;
        input expected_led_strip_address_valid_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_led_strip_address_o === (expected_led_strip_address_o ^ led_strip_address_o ^ expected_led_strip_address_o) &&
                expected_led_strip_address_valid_o === (expected_led_strip_address_valid_o ^ led_strip_address_valid_o ^ expected_led_strip_address_valid_o)) begin
                $display("PASS");
                $display("  Outputs: led_strip_address_o=%h, led_strip_address_valid_o=%b",
                         led_strip_address_o, led_strip_address_valid_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led_strip_address_o=%h, led_strip_address_valid_o=%b",
                         expected_led_strip_address_o, expected_led_strip_address_valid_o);
                $display("  Got:      led_strip_address_o=%h, led_strip_address_valid_o=%b",
                         led_strip_address_o, led_strip_address_valid_o);
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

endmodule
