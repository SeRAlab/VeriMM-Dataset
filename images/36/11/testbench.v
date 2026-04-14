`timescale 1ns/1ps

module image_dilation_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] image;
    wire [8:0] dilated_image;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    image_dilation dut (
        .image(image),
        .dilated_image(dilated_image)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Pixels Zero", test_num);
        image = 9'h000;
        #1;

        check_outputs(9'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All Pixels One", test_num);
        image = 9'h1FF;
        #1;

        check_outputs(9'h1FF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Center Pixel Only (Bit 4)", test_num);
        image = 9'h010;
        #1;

        check_outputs(9'h1FF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Top-Left Corner (Bit 0)", test_num);
        image = 9'h001;
        #1;

        check_outputs(9'h01B);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Top-Center Edge (Bit 1)", test_num);
        image = 9'h002;
        #1;

        check_outputs(9'h03F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Top-Right Corner (Bit 2)", test_num);
        image = 9'h004;
        #1;

        check_outputs(9'h036);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Middle-Left Edge (Bit 3)", test_num);
        image = 9'h008;
        #1;

        check_outputs(9'h0DB);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Middle-Right Edge (Bit 5)", test_num);
        image = 9'h020;
        #1;

        check_outputs(9'h1B6);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bottom-Left Corner (Bit 6)", test_num);
        image = 9'h040;
        #1;

        check_outputs(9'h0D8);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bottom-Center Edge (Bit 7)", test_num);
        image = 9'h080;
        #1;

        check_outputs(9'h1F8);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bottom-Right Corner (Bit 8)", test_num);
        image = 9'h100;
        #1;

        check_outputs(9'h1B0);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Opposite Corners (Bits 0 and 8)", test_num);
        image = 9'h101;
        #1;

        check_outputs(9'h1B3);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sparse Diagonal (Bits 2 and 6)", test_num);
        image = 9'h044;
        #1;

        check_outputs(9'h0FE);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("image_dilation Testbench");
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
        input [8:0] expected_dilated_image;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dilated_image === (expected_dilated_image ^ dilated_image ^ expected_dilated_image)) begin
                $display("PASS");
                $display("  Outputs: dilated_image=%h",
                         dilated_image);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dilated_image=%h",
                         expected_dilated_image);
                $display("  Got:      dilated_image=%h",
                         dilated_image);
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
