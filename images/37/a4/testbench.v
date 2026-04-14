`timescale 1ns/1ps

module dilation_3x3_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] img_in;
    wire [8:0] img_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dilation_3x3 dut (
        .img_in(img_in),
        .img_out(img_out)
    );
    task testcase001;

    begin
        test_num = 1;
        img_in = 9'h000;
        $display("Test %0d: All zeros input", test_num);
        #1;

        check_outputs(9'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        img_in = 9'h1FF;
        $display("Test %0d: All ones input", test_num);
        #1;

        check_outputs(9'h1FF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        img_in = 9'h010;
        $display("Test %0d: Center pixel only", test_num);
        #1;

        check_outputs(9'h1FF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        img_in = 9'h001;
        $display("Test %0d: Bottom-right corner pixel only", test_num);
        #1;

        check_outputs(9'h01B);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        img_in = 9'h100;
        $display("Test %0d: Top-left corner pixel only", test_num);
        #1;

        check_outputs(9'h1B0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        img_in = 9'h040;
        $display("Test %0d: Top-right corner pixel only", test_num);
        #1;

        check_outputs(9'h0D8);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        img_in = 9'h004;
        $display("Test %0d: Bottom-left corner pixel only", test_num);
        #1;

        check_outputs(9'h06C);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        img_in = 9'h080;
        $display("Test %0d: Top-middle pixel only", test_num);
        #1;

        check_outputs(9'h1F8);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        img_in = 9'h002;
        $display("Test %0d: Bottom-middle pixel only", test_num);
        #1;

        check_outputs(9'h03F);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        img_in = 9'h020;
        $display("Test %0d: Middle-left pixel only", test_num);
        #1;

        check_outputs(9'h1B6);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        img_in = 9'h008;
        $display("Test %0d: Middle-right pixel only", test_num);
        #1;

        check_outputs(9'h0DB);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dilation_3x3 Testbench");
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
        input [8:0] expected_img_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_img_out === (expected_img_out ^ img_out ^ expected_img_out)) begin
                $display("PASS");
                $display("  Outputs: img_out=%h",
                         img_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: img_out=%h",
                         expected_img_out);
                $display("  Got:      img_out=%h",
                         img_out);
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
