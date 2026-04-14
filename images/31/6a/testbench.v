`timescale 1ns/1ps

module image_convolution_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] kernel;
    reg [7:0] pixel;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    image_convolution dut (
        .kernel(kernel),
        .pixel(pixel),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        kernel = 9'b000_000_000;
        pixel = 8'h00;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        kernel = 9'b000_010_000;
        pixel = 8'h45;

        #1;


        check_outputs(8'h45);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        kernel = 9'b000_000_011;
        pixel = 8'h0A;

        #1;


        check_outputs(8'h14);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        kernel = 9'b111_111_111;
        pixel = 8'h00;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        kernel = 9'b100_000_000;
        pixel = 8'hFF;

        #1;


        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        kernel = 9'b000_000_111;
        pixel = 8'h80;


        #1;



        check_outputs(8'hFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        kernel = 9'b111_111_111;
        pixel = 8'h05;

        #1;


        check_outputs(8'h2D);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("image_convolution Testbench");
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
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
