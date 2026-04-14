`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] foodX;
    reg [5:0] foodY;
    reg [1:0] snake;
    reg [9:0] xPos;
    reg [9:0] yPos;
    wire [11:0] vgaData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .foodX(foodX),
        .foodY(foodY),
        .snake(snake),
        .xPos(xPos),
        .yPos(yPos),
        .vgaData(vgaData)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Background (Empty space)", test_num);
        xPos = 10'd0;
        yPos = 10'd0;
        snake = 2'b00;
        foodX = 6'd10;
        foodY = 6'd10;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Food item", test_num);
        foodX = 6'd5;
        foodY = 6'd8;
        xPos = 10'd80;
        yPos = 10'd128;
        snake = 2'b00;
        #1;

        check_outputs(12'hF00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Snake Head", test_num);
        snake = 2'b10;
        xPos = 10'd200;
        yPos = 10'd200;
        foodX = 6'd30;
        foodY = 6'd30;
        #1;

        check_outputs(12'h0F0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Snake Body", test_num);
        snake = 2'b01;
        xPos = 10'd200;
        yPos = 10'd200;
        #1;

        check_outputs(12'hAF0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Wall section", test_num);
        snake = 2'b11;
        xPos = 10'd0;
        yPos = 10'd0;
        #1;

        check_outputs(12'h0FF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Priority Check (Head over Food)", test_num);
        foodX = 6'd20;
        foodY = 6'd20;
        xPos = 10'd320;
        yPos = 10'd320;
        snake = 2'b10;
        #1;

        check_outputs(12'h0F0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max Boundary Food", test_num);
        foodX = 6'd63;
        foodY = 6'd63;
        xPos = 10'd1008;
        yPos = 10'd1008;
        snake = 2'b00;
        #1;

        check_outputs(12'hF00);
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
        input [11:0] expected_vgaData;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_vgaData === (expected_vgaData ^ vgaData ^ expected_vgaData)) begin
                $display("PASS");
                $display("  Outputs: vgaData=%h",
                         vgaData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vgaData=%h",
                         expected_vgaData);
                $display("  Got:      vgaData=%h",
                         vgaData);
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
