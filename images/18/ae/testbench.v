`timescale 1ns/1ps

module hough_transform_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] binary_image;
    wire [15:0] accumulator;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hough_transform dut (
        .binary_image(binary_image),
        .accumulator(accumulator)
    );
    task testcase001;

        begin
            test_num = 1;
            binary_image = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            binary_image = 16'h000F;

            #1;


            check_outputs(16'h0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            binary_image = 16'h0F00;

            #1;


            check_outputs(16'h0004);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            binary_image = 16'h1111;

            #1;


            check_outputs(16'h0010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            binary_image = 16'h8888;

            #1;


            check_outputs(16'h0080);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            binary_image = 16'h8421;

            #1;


            check_outputs(16'h0100);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            binary_image = 16'h1248;

            #1;


            check_outputs(16'h0200);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            binary_image = 16'h00F0 | 16'h2222;

            #1;


            check_outputs(16'h0022);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            binary_image = 16'hA5A5;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            binary_image = 16'hFFFF;


            #1;



            check_outputs(16'h03FF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hough_transform Testbench");
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
        input [15:0] expected_accumulator;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_accumulator === (expected_accumulator ^ accumulator ^ expected_accumulator)) begin
                $display("PASS");
                $display("  Outputs: accumulator=%h",
                         accumulator);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: accumulator=%h",
                         expected_accumulator);
                $display("  Got:      accumulator=%h",
                         accumulator);
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
