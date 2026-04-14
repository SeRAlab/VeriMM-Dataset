`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] I_colour;
    wire [7:0] blue;
    wire [7:0] green;
    wire [7:0] red;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I_colour(I_colour),
        .blue(blue),
        .green(green),
        .red(red)
    );
    task testcase001;

    begin
        test_num = 1;
        I_colour = 4'h0;
        $display("Test Case %0d: Index 0 (Black)", test_num);
        #1;

        check_outputs(8'h00, 8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        I_colour = 4'h1;
        $display("Test Case %0d: Index 1 (Blue)", test_num);
        #1;

        check_outputs(8'hAA, 8'h00, 8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        I_colour = 4'h2;
        $display("Test Case %0d: Index 2 (Green)", test_num);
        #1;

        check_outputs(8'h00, 8'hAA, 8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        I_colour = 4'h3;
        $display("Test Case %0d: Index 3 (Cyan)", test_num);
        #1;

        check_outputs(8'hAA, 8'hAA, 8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        I_colour = 4'h4;
        $display("Test Case %0d: Index 4 (Red)", test_num);
        #1;

        check_outputs(8'h00, 8'h00, 8'hAA);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        I_colour = 4'h5;
        $display("Test Case %0d: Index 5 (Magenta)", test_num);
        #1;

        check_outputs(8'hAA, 8'h00, 8'hAA);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        I_colour = 4'h6;
        $display("Test Case %0d: Index 6 (Brown)", test_num);
        #1;

        check_outputs(8'h00, 8'h55, 8'hAA);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        I_colour = 4'h7;
        $display("Test Case %0d: Index 7 (Light Gray)", test_num);
        #1;

        check_outputs(8'hAA, 8'hAA, 8'hAA);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        I_colour = 4'h8;
        $display("Test Case %0d: Index 8 (Dark Gray)", test_num);
        #1;

        check_outputs(8'h55, 8'h55, 8'h55);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        I_colour = 4'h9;
        $display("Test Case %0d: Index 9 (Light Blue)", test_num);
        #1;

        check_outputs(8'hFF, 8'h55, 8'h55);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        I_colour = 4'hA;
        $display("Test Case %0d: Index 10 (Light Green)", test_num);
        #1;

        check_outputs(8'h55, 8'hFF, 8'h55);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        I_colour = 4'hB;
        $display("Test Case %0d: Index 11 (Light Cyan)", test_num);
        #1;

        check_outputs(8'hFF, 8'hFF, 8'h55);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        I_colour = 4'hC;
        $display("Test Case %0d: Index 12 (Light Red)", test_num);
        #1;

        check_outputs(8'h55, 8'h55, 8'hFF);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        I_colour = 4'hD;
        $display("Test Case %0d: Index 13 (Light Magenta)", test_num);
        #1;

        check_outputs(8'hFF, 8'h55, 8'hFF);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        I_colour = 4'hE;
        $display("Test Case %0d: Index 14 (Yellow)", test_num);
        #1;

        check_outputs(8'h55, 8'hFF, 8'hFF);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        I_colour = 4'hF;
        $display("Test Case %0d: Index 15 (White)", test_num);
        #1;

        check_outputs(8'hFF, 8'hFF, 8'hFF);
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
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [7:0] expected_blue;
        input [7:0] expected_green;
        input [7:0] expected_red;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_blue === (expected_blue ^ blue ^ expected_blue) &&
                expected_green === (expected_green ^ green ^ expected_green) &&
                expected_red === (expected_red ^ red ^ expected_red)) begin
                $display("PASS");
                $display("  Outputs: blue=%h, green=%h, red=%h",
                         blue, green, red);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: blue=%h, green=%h, red=%h",
                         expected_blue, expected_green, expected_red);
                $display("  Got:      blue=%h, green=%h, red=%h",
                         blue, green, red);
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
