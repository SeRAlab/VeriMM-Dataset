`timescale 1ns/1ps

module histogram_equalization_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel_in;
    wire [7:0] pixel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    histogram_equalization dut (
        .pixel_in(pixel_in),
        .pixel_out(pixel_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Minimum boundary (Black pixel)", test_num);
        pixel_in = 8'h00;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Maximum boundary (White pixel)", test_num);
        pixel_in = 8'hFF;

        #1;


        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Mid-range value", test_num);
        pixel_in = 8'h80;

        #1;


        check_outputs(8'h80);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Lower-quartile value", test_num);
        pixel_in = 8'h40;

        #1;


        check_outputs(8'h40);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Upper-quartile value", test_num);
        pixel_in = 8'hC0;

        #1;


        check_outputs(8'hC0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Near-zero value", test_num);
        pixel_in = 8'h01;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Near-max value", test_num);
        pixel_in = 8'hFE;
        #1;

        check_outputs(8'hFE);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("histogram_equalization Testbench");
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
        input [7:0] expected_pixel_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pixel_out === (expected_pixel_out ^ pixel_out ^ expected_pixel_out)) begin
                $display("PASS");
                $display("  Outputs: pixel_out=%h",
                         pixel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pixel_out=%h",
                         expected_pixel_out);
                $display("  Got:      pixel_out=%h",
                         pixel_out);
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
