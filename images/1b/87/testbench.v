`timescale 1ns/1ps

module sobel_edge_detection_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_0_0;
    reg [7:0] pixel_0_1;
    reg [7:0] pixel_0_2;
    reg [7:0] pixel_1_0;
    reg [7:0] pixel_1_1;
    reg [7:0] pixel_1_2;
    reg [7:0] pixel_2_0;
    reg [7:0] pixel_2_1;
    reg [7:0] pixel_2_2;
    wire [7:0] edge_strength;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sobel_edge_detection dut (
        .pixel_0_0(pixel_0_0),
        .pixel_0_1(pixel_0_1),
        .pixel_0_2(pixel_0_2),
        .pixel_1_0(pixel_1_0),
        .pixel_1_1(pixel_1_1),
        .pixel_1_2(pixel_1_2),
        .pixel_2_0(pixel_2_0),
        .pixel_2_1(pixel_2_1),
        .pixel_2_2(pixel_2_2),
        .edge_strength(edge_strength)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All black image", test_num);
        pixel_0_0 = 8'd0; pixel_0_1 = 8'd0; pixel_0_2 = 8'd0;
        pixel_1_0 = 8'd0; pixel_1_1 = 8'd0; pixel_1_2 = 8'd0;
        pixel_2_0 = 8'd0; pixel_2_1 = 8'd0; pixel_2_2 = 8'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Uniform gray image", test_num);
        pixel_0_0 = 8'd128; pixel_0_1 = 8'd128; pixel_0_2 = 8'd128;
        pixel_1_0 = 8'd128; pixel_1_1 = 8'd128; pixel_1_2 = 8'd128;
        pixel_2_0 = 8'd128; pixel_2_1 = 8'd128; pixel_2_2 = 8'd128;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Strong vertical edge", test_num);
        pixel_0_0 = 8'd0;   pixel_0_1 = 8'd128; pixel_0_2 = 8'd255;
        pixel_1_0 = 8'd0;   pixel_1_1 = 8'd128; pixel_1_2 = 8'd255;
        pixel_2_0 = 8'd0;   pixel_2_1 = 8'd128; pixel_2_2 = 8'd255;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Strong horizontal edge", test_num);
        pixel_0_0 = 8'd0;   pixel_0_1 = 8'd0;   pixel_0_2 = 8'd0;
        pixel_1_0 = 8'd128; pixel_1_1 = 8'd128; pixel_1_2 = 8'd128;
        pixel_2_0 = 8'd255; pixel_2_1 = 8'd255; pixel_2_2 = 8'd255;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Low contrast horizontal edge", test_num);
        pixel_0_0 = 8'd10; pixel_0_1 = 8'd10; pixel_0_2 = 8'd10;
        pixel_1_0 = 8'd10; pixel_1_1 = 8'd10; pixel_1_2 = 8'd10;
        pixel_2_0 = 8'd20; pixel_2_1 = 8'd20; pixel_2_2 = 8'd20;
        #1;

        check_outputs(8'd40);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Single pixel noise", test_num);
        pixel_0_0 = 8'd0;   pixel_0_1 = 8'd0;   pixel_0_2 = 8'd0;
        pixel_1_0 = 8'd0;   pixel_1_1 = 8'd255; pixel_1_2 = 8'd0;
        pixel_2_0 = 8'd0;   pixel_2_1 = 8'd0;   pixel_2_2 = 8'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Diagonal gradient", test_num);
        pixel_0_0 = 8'd100; pixel_0_1 = 8'd0; pixel_0_2 = 8'd0;
        pixel_1_0 = 8'd0;   pixel_1_1 = 8'd0; pixel_1_2 = 8'd0;
        pixel_2_0 = 8'd0;   pixel_2_1 = 8'd0; pixel_2_2 = 8'd0;
        #1;

        check_outputs(8'd200);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Complex pattern", test_num);
        pixel_0_0 = 8'd45;  pixel_0_1 = 8'd12;  pixel_0_2 = 8'd88;
        pixel_1_0 = 8'd23;  pixel_1_1 = 8'd0;   pixel_1_2 = 8'd55;
        pixel_2_0 = 8'd110; pixel_2_1 = 8'd34;  pixel_2_2 = 8'd9;
        #1;

        check_outputs(8'd36);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sobel_edge_detection Testbench");
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
        input [7:0] expected_edge_strength;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_edge_strength === (expected_edge_strength ^ edge_strength ^ expected_edge_strength)) begin
                $display("PASS");
                $display("  Outputs: edge_strength=%h",
                         edge_strength);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: edge_strength=%h",
                         expected_edge_strength);
                $display("  Got:      edge_strength=%h",
                         edge_strength);
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
